
import Foundation

public struct URLPath {
   
   public static let shared = URLPath()
   
   // Flags url
   public let flagsURL: String = "https://www/wellwin-app.com/data/v1/shared/flags/flags.json"
   
   // Base url
   private var baseURL: URL {
      URL(string: "https://www.wellwin-app.com/data/v1")!
   }
   
   // Game url
   public func gamesURL(for games: GamesEndPoint = GamesEndPoint()) -> URL? {
      let url: String = games.path()
      return absoluteURL(for: url)
   }
   
   // Absolute URL
   public func absoluteURL(for path: String) -> URL? {
      let url = baseURL.appendingPathComponent(path)
      let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
      guard let urlComponents = components else {
         return nil
      }
      return urlComponents.url
   }
}


// Expandable enum for the future
public enum GamesEndPoint {
   
   case football
   case basketball
   case tennis
   case volleyball
   case hockey
   
   public init(index: Int = 1) {
      switch index {
         case 1:
            self = .football
         case 2:
            self = .basketball
         case 3:
            self = .tennis
         case 4:
            self = .volleyball
         case 5:
            self = .hockey
         default:
            self = .football
      }
   }
   
   func path() -> String {
      switch self {
         case .football:
            return "/football/football.json"
         case .basketball:
            return "/basketball/basketball.json"
         case .tennis:
            return "/tennis/tennis.json"
         case .volleyball:
            return "/volleyball/volleyball.json"
         case .hockey:
            return "/hockey/hockey.json"
      }
   }
}
