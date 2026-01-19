import Foundation

struct Weather: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let windSpeed: Double
    let icon: String
}
