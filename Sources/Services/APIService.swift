import Foundation
import Alamofire

class APIService {
    enum APIServiceError: LocalizedError {
        case invalidURL

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            }
        }
    }

    private struct OpenWeatherErrorResponse: Decodable {
        let cod: String?
        let message: String?
    }

    func fetchWeather(for city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
        guard var components = URLComponents(string: "\(Config.baseURL)/weather") else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }

        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: Config.apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        guard let url = components.url else {
            completion(.failure(APIServiceError.invalidURL))
            return
        }

        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Weather.self, queue: .main) { response in
                switch response.result {
                case .success(let weather):
                    completion(.success(weather))
                case .failure(let error):
                    if let data = response.data,
                       let apiError = try? JSONDecoder().decode(OpenWeatherErrorResponse.self, from: data),
                       let message = apiError.message,
                       !message.isEmpty {
                        completion(.failure(NSError(domain: "OpenWeatherMap", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: message])))
                        return
                    }
                    completion(.failure(error))
                }
            }
    }
}
