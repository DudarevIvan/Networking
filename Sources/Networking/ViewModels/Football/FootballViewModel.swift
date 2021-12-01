//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 01.12.2021.
//

import Combine

public final class FootballViewModel: ObservableObject {
    
    // Shared
    public static let shared: FootballViewModel = .init()
    
    // Networking
    private var service = NetworkService.shared
    
    // Game data
    @Published public var football: Football = .init()
    
    // Errors
    @Published public var networkError: NetworkError?
    
    // Save Published
    private var cancellableSet: Set<AnyCancellable> = []
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
    
    private init() {
        self.service.fetchGame(endPoint: Games.football)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.networkError = error
                    }},
                receiveValue:  { [unowned self] value in
                    football = value
                })
            .store(in: &self.cancellableSet)
    }
}
