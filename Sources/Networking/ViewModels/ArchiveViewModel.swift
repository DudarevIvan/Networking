//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//

import SwiftUI
import Combine
import ServiceLocator
import Networking

public final class ArchiveViewModel: ObservableObject {
    
    @Published public var archive: Archive = .init()
    @Published public var pathArchive: String = "/football/argentina/argentinaLigaProfesional-2016.json"
    
    //private var networking = Networking.shared
    // MARK: Service Locator
    private var networking: Networking
    private var serviceLocator: () = Services.shared.registerService(singleton: Networking.shared)
    
    public init() {
        self.networking = Services.shared.get()
        $pathArchive
            .flatMap { (pathArchive) -> AnyPublisher<Archive, Never> in
                Networking.shared.fetchArchive(for: pathArchive)
            }
            .assign(to: \.archive, on: self)
            .store(in: &self.cancellableSet)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    deinit {
        for cancell in cancellableSet {
            cancell.cancel()
        }
    }
}
