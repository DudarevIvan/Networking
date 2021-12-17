//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 03.12.2021.
//

import Combine

public final class SportViewModel: ObservableObject {
    
    // Networking
    private var service = NetworkingService.shared
    
    // Sports data
    @Published public var data: SportModel?
    
    // Sports
    @Published public var sports: Sports = .init()
    
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
        $sports
            .setFailureType(to: NetworkingError.self)
            .flatMap { (s) -> AnyPublisher<SportModel, NetworkingError> in
                self.service.fetchSport(for: s)
                    .eraseToAnyPublisher()
                    }
//        self.service.fetchSport(for: sports)
//            .eraseToAnyPublisher()
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
