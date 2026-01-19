import Foundation

class LocalStorage {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    private struct CachedWeather: Codable {
        let weather: Weather
        let savedAt: Date
    }

    private func key(for city: City) -> String {
        let normalized = city.name
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        return "cached_weather_\(normalized)"
    }

    func saveWeather(_ weather: Weather, for city: City) {
        let cached = CachedWeather(weather: weather, savedAt: Date())
        guard let data = try? JSONEncoder().encode(cached) else { return }
        userDefaults.set(data, forKey: key(for: city))
    }
    
    func loadWeather(for city: City) -> Weather? {
        guard let data = userDefaults.data(forKey: key(for: city)) else { return nil }
        guard let cached = try? JSONDecoder().decode(CachedWeather.self, from: data) else { return nil }
        return cached.weather
    }

    func loadWeatherSavedAt(for city: City) -> Date? {
        guard let data = userDefaults.data(forKey: key(for: city)) else { return nil }
        guard let cached = try? JSONDecoder().decode(CachedWeather.self, from: data) else { return nil }
        return cached.savedAt
    }
}
