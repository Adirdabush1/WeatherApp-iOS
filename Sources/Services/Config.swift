import Foundation

struct Config {
    static var apiKey: String {
        if let key = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_API_KEY") as? String, !key.isEmpty {
            return key
        }
        #if DEBUG
        return Secrets.openWeatherApiKey
        #else
        fatalError("Missing OPENWEATHER_API_KEY in Info.plist")
        #endif
    }
    static let baseURL = "https://api.openweathermap.org/data/2.5"
}
