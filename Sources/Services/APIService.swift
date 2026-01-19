import Foundation
import Alamofire

class APIService {
    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        let url = ""\(Config.baseURL)/weather?q=\(city)&appid=\(Config.apiKey)&units=metric""
        
        // Alamofire request placeholder
        AF.request(url).responseDecodable(of: Weather.self) { response in
            completion(response.result)
        }
    }
}
