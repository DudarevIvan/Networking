//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 02.12.2021.
//

import Foundation

public enum Sports: String {
    case Football
    case Basketball
    case Tennis
    case Volleyball
    case Hockey
}


extension Sports {
    // The default sport is Football
    public init() {
        self = .Football
    }
    
    public var name: String {
        self.rawValue
    }
    
    public func path() -> String {
        switch self {
        case .Football:
            return "/football/football.json"
        case .Basketball:
            return "/basketball/basketball.json"
        case .Tennis:
            return "/tennis/tennis.json"
        case .Volleyball:
            return "/volleyball/volleyball.json"
        case .Hockey:
            return "/hockey/hockey.json"
        }
    }
}
