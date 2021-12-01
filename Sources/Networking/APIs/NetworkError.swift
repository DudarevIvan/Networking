//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 01.12.2021.
//

import Foundation

public enum NetworkError: Error, LocalizedError, Identifiable {
   
   public var id: String { localizedDescription }
   
   case urlError(URLError)
   case responseError(Int)
   case decodingError(DecodingError)
   case genericError
   
   var localizedDescription: String {
      switch self {
         case .urlError(let error):
            return error.localizedDescription
         case .decodingError(let error):
            return error.localizedDescription
         case .responseError(let status):
            return "Bad response code: \(status)"
         case .genericError:
            return "An unknown error has been occured"
      }
   }
}
