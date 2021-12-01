//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//
import Foundation

// Main
public struct Games: Codable {
   public var countries: [Country]?
   public var numberOfGames: Int?
}

// Country
public struct Country: Codable, Identifiable {
   public var id: Int?
   public var name: String?
   public var shortName: String?
   public var numberOfGames: Int?
   public var leagues: [Leagues]?
//   public init(id: Int?, name: String?, shortName: String?, numberOfGames: Int?, leagues: [Leagues]?) {
//      self.id = id
//      self.name = name
//      self.shortName = shortName
//      self.numberOfGames = numberOfGames
//      self.leagues = leagues
//   }
}

// Leagues
public struct Leagues: Codable, Identifiable {
   public var id: Int?
   public var name: String?
   public var icon: String?
   public var numberOfGames: Int?
   public var seasons: [Seasons]?
//   public init(id: Int?, name: String?, icon: String? = nil, numberOfGames: Int?, seasons: [Seasons]?) {
//      self.id = id
//      self.name = name
//      self.icon = icon
//      self.numberOfGames = numberOfGames
//      self.seasons = seasons
//   }
}

// Seasons
public struct Seasons: Codable, Identifiable {
   public var id: Int?
   public var season: String?
   public let numberOfGames: Int?
   public var archive: String?   
//   public init(id: Int?, season: String?, numberOfGames: Int?, archive: String?) {
//      self.id = id
//      self.season = season
//      self.numberOfGames = numberOfGames
//      self.archive = archive
//   }
}

