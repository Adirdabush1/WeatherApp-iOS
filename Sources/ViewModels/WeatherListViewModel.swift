import Foundation

class WeatherListViewModel {
    var cities: [City] = []
    var weathers: [Weather] = []

    func fetchWeather(for city: City, completion: @escaping () -> Void) {
        // כאן נשתמש ב-APIService
    }
}
