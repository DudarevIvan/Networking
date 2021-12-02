//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//
import Foundation

// Main
public struct Football: Codable {
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
}

// Leagues
public struct Leagues: Codable, Identifiable {
   public var id: Int?
   public var name: String?
   public var icon: String?
   public var numberOfGames: Int?
   public var seasons: [Seasons]?
}

// Seasons
public struct Seasons: Codable, Identifiable {
   public var id: Int?
   public var season: String?
   public let numberOfGames: Int?
   public var archive: String? 
}

