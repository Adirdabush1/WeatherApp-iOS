import Foundation

/// App-level weather model.
/// Decodes from OpenWeatherMap `/weather` response.
struct Weather: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let windSpeed: Double
    let icon: String

    private enum RootKeys: String, CodingKey {
        case main
        case wind
        case weather
    }

    private enum FlatKeys: String, CodingKey {
        case temp
        case tempMin
        case tempMax
        case humidity
        case windSpeed
        case icon
    }

    private struct Main: Decodable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Int

        private enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }

    private struct Wind: Decodable {
        let speed: Double
    }

    private struct Condition: Decodable {
        let icon: String
    }

    init(from decoder: Decoder) throws {
        // 1) Try decoding the real OpenWeatherMap response (nested JSON)
        if let container = try? decoder.container(keyedBy: RootKeys.self),
           container.contains(.main),
           container.contains(.wind) {
            let main = try container.decode(Main.self, forKey: .main)
            let wind = try container.decode(Wind.self, forKey: .wind)
            let conditions = (try? container.decode([Condition].self, forKey: .weather)) ?? []

            self.temp = main.temp
            self.tempMin = main.tempMin
            self.tempMax = main.tempMax
            self.humidity = main.humidity
            self.windSpeed = wind.speed
            self.icon = conditions.first?.icon ?? ""
            #if DEBUG
            print("[Weather] decoded from API - temp:\(self.temp) icon:\(self.icon)")
            #endif
            return
        }

        // 2) Fallback: decode cached flat JSON representation
        let container = try decoder.container(keyedBy: FlatKeys.self)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.tempMin = try container.decode(Double.self, forKey: .tempMin)
        self.tempMax = try container.decode(Double.self, forKey: .tempMax)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        self.icon = try container.decode(String.self, forKey: .icon)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FlatKeys.self)
        try container.encode(temp, forKey: .temp)
        try container.encode(tempMin, forKey: .tempMin)
        try container.encode(tempMax, forKey: .tempMax)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(windSpeed, forKey: .windSpeed)
        try container.encode(icon, forKey: .icon)
    }
}

#if DEBUG
extension Weather: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Weather(temp:\(temp), min:\(tempMin), max:\(tempMax), humidity:\(humidity), wind:\(windSpeed), icon:\(icon))"
    }
}
#endif
