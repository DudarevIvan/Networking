//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 01.12.2021.
//

import Combine

public final class FootballArchiveViewModel: ObservableObject {
   
   // Networking
   private var service = NetworkService.shared
   
   // Archive
   @Published public var archive: FootballArchive = .init()
   
   // Paths
   @Published public var pathToArchive: String
   
   // Errors
   @Published public var networkError: NetworkError?
   
   // Save Published
   private var cancellableSet: Set<AnyCancellable> = []
   deinit {
      for cancell in cancellableSet {
         cancell.cancel()
      }
   }
   
   public init(url: String) {
      self.pathToArchive = url
      $pathToArchive
         .setFailureType(to: NetworkError.self)
         .flatMap { [self] (url) -> AnyPublisher<FootballArchive, NetworkError> in
            service.fetchArchive(for: url)
               .eraseToAnyPublisher()
         }
         .sink(receiveCompletion:  {[unowned self] (completion) in
                  if case let .failure(error) = completion {
                     networkError = error
                  }},
               receiveValue: { [unowned self] in
                  archive = $0
               })
         .store(in: &self.cancellableSet)
   }
}
