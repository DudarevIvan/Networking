//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 03.12.2021.
//

import Combine

public final class HockeyViewModel: ObservableObject {
    
    // Shared
    public static let shared: HockeyViewModel = .init()
    
    // Networking
    private var service = NetworkingService.shared
    
    // Sports data
    @Published public var hockey: Hockey = .init()
    
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
        self.service.fetchSport(for: Sports.Hockey)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.networkingError = error
                    }},
                receiveValue: { [unowned self] value in
                    hockey = value
                }
            )
            .store(in: &self.cancellableSet)
    }
}
