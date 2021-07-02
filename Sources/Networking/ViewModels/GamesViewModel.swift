//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 6/4/21.
//

import SwiftUI
import Combine

public final class GamesViewModel: ObservableObject {
   
   // Networking
   private var networking = Networking.shared
   
   // Games
   @Published public var games: Games = .init()
   @Published public var indexEndpoint: Int = 1 // Football
   
   // Save Published
   private var cancellableSet: Set<AnyCancellable> = []
   deinit {
      for cancell in cancellableSet {
         cancell.cancel()
      }
   }
   
   public init() {
      $indexEndpoint
         .flatMap { [self] (indexEndpoint) -> AnyPublisher<Games, Never> in
            networking.fetchGames(endPoint: GamesEndPoint(index: indexEndpoint))
         }
         .assign(to: \.games, on: self)
         .store(in: &self.cancellableSet)
   }
}
