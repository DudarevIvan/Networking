//
//  File.swift
//  
//
//  Created by Ivan Dudarev on 4/28/21.
//

import Foundation

public struct URLPath {
    
    public static let shared = URLPath()
    
    private var baseURL: URL {
        URL(string: "https://www.wellwin-app.com/data")!
    }
    
    // List counties, leagues, seasons for game
    public func gamesURL(for games: EndPoint = EndPoint()) -> URL? {
        let url: String = games.path()
        return absoluteURL(for: url)
    }
    
    // Archive (and more)
    public func absoluteURL(for path: String) -> URL? {
        let url = baseURL.appendingPathComponent(path)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let urlComponents = components else {
            return nil
        }
        return urlComponents.url
    }    
}


public enum EndPoint {
    
    case basketball
    case football
    case hockey
    case tennis
    
    public init(index: Int = 2) {
        switch index {
        case 1:
            self = .basketball
        case 2:
            self = .football
        case 3:
            self = .hockey
        case 4:
            self = .tennis
        default:
            self = .football
        }
    }
    
    func path() -> String {
        switch self {
        case .basketball:
            return "/basketball/main"
        case .football:
            return "/football/main"
        case .hockey:
            return "/hockey/main"
        case .tennis:
            return "/tennis/main"
        }
    }
}
