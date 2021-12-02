
import Foundation

public struct URLPath {
    
    public static let shared: URLPath = .init()
    private init() {}
    
    // Flags url
    public let flagsURL: String = "https://www/wellwin-app.com/data/v1/shared/flags/flags.json"
    // Base url
    private let baseURL: URL = URL(string: "https://www.wellwin-app.com/data/v1")!
    
    // Sport url
    public func sportURL(for sport: Sports = .init()) -> URL? {
        let url: String = sport.path()
        return absoluteURL(for: url)
    }
    
    // Archive url
    public func archiveURL(for path: String) -> URL? {
        absoluteURL(for: path)
    }
    
    // Absolute URL
    private func absoluteURL(for path: String) -> URL? {
        let url = baseURL.appendingPathComponent(path)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let urlComponents = components else {
            return nil
        }
        return urlComponents.url
    }
}
