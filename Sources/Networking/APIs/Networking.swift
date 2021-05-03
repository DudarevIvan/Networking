//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//

import Foundation
import Combine

public struct Networking {
    
    public static let shared = Networking()
    
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
    public func fetchGames(endPoint: EndPoint) -> AnyPublisher<[Country], Never> {
        guard let url = urlPath.gamesURL(for: endPoint) else {
            return Just([Country]()).eraseToAnyPublisher()
        }
        return fetch(url)
            .map { (response: GamesResponse) -> [Country] in
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
