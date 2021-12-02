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
    private var service = NetworkingService.shared
    
    // Sports data
    @Published public var football: Football = .init()
    
    // Errors
    @Published public var networkingError: NetworkingError?
    
    // Save Published
    private var cancellableSet: Set<AnyCancellable> = []
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
    
    private init() {
        self.service.fetchSport(for: Sports.Football)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.networkingError = error
                    }},
                receiveValue: { [unowned self] value in
                    football = value
                }
            )
            .store(in: &self.cancellableSet)
    }
}
