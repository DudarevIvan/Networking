//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 6/4/21.
//

import SwiftUI
import Combine

public final class ArchiveViewModel: ObservableObject {
   
   // Networking
   private var networking = Networking.shared
   
   // Archive
   @Published public var archive: Archive = .init()
   @Published public var pathArchive: String = .init()
   
   // Save Published
   private var cancellableSet: Set<AnyCancellable> = []
   deinit {
      for cancell in cancellableSet {
         cancell.cancel()
      }
   }
   
   private init() {
      $pathArchive
         .flatMap { (pathArchive) -> AnyPublisher<Archive, Never> in
            self.networking.fetchArchive(for: pathArchive)
         }
         .assign(to: \.archive, on: self)
         .store(in: &self.cancellableSet)
   }
}
