//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 03.12.2021.
//

import Combine

public final class ArchiveViewModel<T: Decodable>: ObservableObject {
    
    // Networking
    private var service = NetworkingService.shared
    
    // Archive
    @Published public var archive: T?
    
    // Errors
    @Published public var networkingError: NetworkingError?
    
    // Save Published
    private var cancellableSet: Set<AnyCancellable> = []
    deinit {
        for cancell in cancellableSet {
            cancell.cancel()
        }
    }
    
    public init(url: String) {
        service.fetchArchive(for: url)
            .eraseToAnyPublisher()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        self.networkingError = error
                    }},
                receiveValue: { [unowned self] archive in
                    self.archive = archive
                }
            )
            .store(in: &self.cancellableSet)
    }
}
