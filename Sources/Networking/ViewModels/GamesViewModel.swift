//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//

import SwiftUI
import Combine
import ServiceLocator

public final class GamesViewModel: ObservableObject {
    
    @Published public var countries: [Country] = .init()
    @Published public var flags: [Image] = .init()
    @Published public var indexEndpoint: Int = 2 // Football

    // MARK: Service Locator
    private var networking: Networking
    private var serviceLocator: () = Services.shared.registerService(singleton: Networking.shared)
    
    public init() {
        self.networking = Services.shared.get()
        $indexEndpoint
            .flatMap { [self] (indexEndpoint) -> AnyPublisher<[Country], Never> in
                networking.fetchGames(endPoint: EndPoint(index: indexEndpoint))
            }
            .assign(to: \.countries, on: self)
            .store(in: &self.cancellableSet)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    deinit {
        for cancell in cancellableSet {
            cancell.cancel()
        }
    }
}
