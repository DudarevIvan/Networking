//
//  NetworkService.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//

import Foundation
import Combine
import SwiftUI

public final class NetworkService {
    
    public static let shared: NetworkService = .init()
    
    private let urlPath = URLPath.shared
    
    public init() {}
    
    // Save Published
    private var cancellableSet: Set<AnyCancellable> = []
    deinit {
        for cancell in cancellableSet {
            cancell.cancel()
        }
    }
    
    // Generic fetch
    private func fetch<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
       URLSession.shared.dataTaskPublisher(for: url)
          .tryMap { (data, response) -> Data in
             guard let httpResponse = response as? HTTPURLResponse,
                   200...299 ~= httpResponse.statusCode else {
                throw NetworkError.responseError (
                   (response as? HTTPURLResponse)?.statusCode ?? 500)
             }
             return data
          }
          .decode(type: T.self, decoder: JSONDecoder())
          .receive(on: RunLoop.main)
          .eraseToAnyPublisher()
    }
    
    // Game
    public func fetchGame<T: Decodable>(endPoint: Games) -> AnyPublisher<T, NetworkError> {
       Future<T, NetworkError> { [unowned self] promise in
          guard let url = urlPath.gameURL(for: endPoint) else {
             return promise(
                .failure(.urlError(URLError(.unsupportedURL))))
          }
          fetch(url)
             .sink(
                receiveCompletion: { (completion) in
                   if case let .failure(error) = completion {
                      switch error {
                         case let urlError as URLError:
                            promise(.failure(.urlError(urlError)))
                         case let decodingError as DecodingError:
                            promise(.failure(.decodingError(decodingError)))
                         case let apiError as NetworkError:
                            promise(.failure(apiError))
                         default:
                            promise(.failure(.genericError))
                      }
                   }
                },
                receiveValue: { promise(.success($0)) })
             .store(in: &self.cancellableSet)
       }
       .eraseToAnyPublisher()
    }
    
    // Archive
    public func fetchArchive<T: Decodable>(for path: String) -> AnyPublisher<T, NetworkError> {
       Future<T, NetworkError> { [unowned self] promise in
          guard let url = urlPath.absoluteURL(for: path) else {
             return promise(
                .failure(.urlError(URLError(.unsupportedURL))))
          }
          fetch(url)
             .sink(
                receiveCompletion: { (completion) in
                   if case let .failure(error) = completion {
                      switch error {
                         case let urlError as URLError:
                            promise(.failure(.urlError(urlError)))
                         case let decodingError as DecodingError:
                            promise(.failure(.decodingError(decodingError)))
                         case let apiError as NetworkError:
                            promise(.failure(apiError))
                         default:
                            promise(.failure(.genericError))
                      }
                   }
                },
                receiveValue: { promise(.success($0)) })
             .store(in: &self.cancellableSet)
       }
       .eraseToAnyPublisher()
    }
}




