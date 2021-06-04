//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//
import Foundation

// Main
public struct Games: Codable {
   
   public let countries: [Country]
   
   public init(countries: [Country]) {
      self.countries = countries
   }
}

// Country
public struct Country: Codable, Identifiable {
   
   public var id: Int?
   public var name: String?
   public var leagues: [Leagues]?
   
   public init(id: Int?, name: String?, leagues: [Leagues]?) {
      self.id = id
      self.name = name
      self.leagues = leagues
   }
}

// Leagues
public struct Leagues: Codable, Identifiable {
   
   public var id: Int?
   public var name: String?
   public var icon: String?
   public var seasons: [Seasons]?
   
   public init(id: Int?, name: String?, icon: String? = nil, seasons: [Seasons]?) {
      self.id = id
      self.name = name
      self.icon = icon
      self.seasons = seasons
   }
}

// Seasons
public struct Seasons: Codable, Identifiable {
   
   public var id: Int?
   public var season: String?
   public var archive: String?
   
   public init(id: Int?, season: String?, archive: String?) {
      self.id = id
      self.season = season
      self.archive = archive
   }
}

