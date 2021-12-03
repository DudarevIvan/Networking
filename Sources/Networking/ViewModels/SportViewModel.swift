//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 03.12.2021.
//

import Combine

public final class SportViewModel<SportGen: Decodable>: ObservableObject {
    
    // Networking
    private var service = NetworkingService.shared
    
    // Sports data
    @Published public var data: SportGen?
    
    // Errors
    @Published public var networkingError: NetworkingError?
    
    // Save Published
    private var cancellableSet: Set<AnyCancellable> = []
    
    deinit {
        for cancellable in cancellableSet {
            cancellable.cancel()
        }
    }
    
    public init() {
        self.service.fetchSport(for: Sports.Football)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.networkingError = error
                    }},
                receiveValue: { [unowned self] value in
                    data = value
                }
            )
            .store(in: &self.cancellableSet)
    }
}
