//
//  Networking.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//

import Foundation
import Combine
import SwiftUI

public struct Networking {
   
   public static let shared: Networking = .init()
   
   private let urlPath = URLPath.shared
   
   public init() {}
   
   // Generic fetch
   private func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
      return URLSession.shared.dataTaskPublisher(for: url)
         .map { $0.data }
         .decode(type: T.self, decoder: JSONDecoder())
         .receive(on: RunLoop.main)
         .eraseToAnyPublisher()
   }
   
   
   // Fetch games
   public func fetchGames(endPoint: GamesEndPoint) -> AnyPublisher<[Country], Never> {
      guard let url = urlPath.gamesURL(for: endPoint) else {
         return Just([Country]()).eraseToAnyPublisher()
      }
      return fetch(url)
         .map { (response: Games) -> [Country] in
            response.countries }
         .replaceError(with: [Country]())
         .eraseToAnyPublisher()
   }
   
   // Fetch archive
   public func fetchArchive(for path: String) -> AnyPublisher<Archive, Never> {
      guard let url = urlPath.absoluteURL(for: path) else {
         return Just(Archive()).eraseToAnyPublisher()
      }
      return fetch(url)
         .replaceError(with: Archive())
         .eraseToAnyPublisher()
   }
}




