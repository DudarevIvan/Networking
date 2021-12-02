//
//  NetworkingService.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//

import Foundation
import Combine
import SwiftUI

public final class NetworkingService {
    
    public static let shared: NetworkingService = .init()
    
    private init() {}
    
    private let url = URLPath.shared
    
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
                throw NetworkingError.responseError (
                   (response as? HTTPURLResponse)?.statusCode ?? 500)
             }
             return data
          }
          .decode(type: T.self, decoder: JSONDecoder())
          .receive(on: RunLoop.main)
          .eraseToAnyPublisher()
    }
    
    // Sport
    public func fetchSport<T: Decodable>(for sport: Sports) -> AnyPublisher<T, NetworkingError> {
       Future<T, NetworkingError> { [unowned self] promise in
          guard let url = url.sportURL(for: sport) else {
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
                         case let apiError as NetworkingError:
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
    public func fetchArchive<T: Decodable>(for path: String) -> AnyPublisher<T, NetworkingError> {
       Future<T, NetworkingError> { [unowned self] promise in
          guard let url = url.archiveURL(for: path) else {
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
                         case let apiError as NetworkingError:
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
