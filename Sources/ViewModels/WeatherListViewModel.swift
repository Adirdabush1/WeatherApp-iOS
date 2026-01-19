import Foundation

class WeatherListViewModel {
    private let apiService: APIService
    private let storage: LocalStorage

    let cities: [City]
    private(set) var weatherByCityName: [String: Weather] = [:]

    var onChange: (() -> Void)?
    var onErrorMessage: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?

    private var isLoading: Bool = false {
        didSet { onLoadingChanged?(isLoading) }
    }

    init(
        cities: [City] = [
            City(name: "Tel Aviv"),
            City(name: "Jerusalem"),
            City(name: "Haifa"),
            City(name: "Eilat")
        ],
        apiService: APIService = APIService(),
        storage: LocalStorage = LocalStorage()
    ) {
        self.cities = cities
        self.apiService = apiService
        self.storage = storage
    }

    func weather(for city: City) -> Weather? {
        weatherByCityName[city.name]
    }

    func load() {
        // 1) Immediately load cached data for offline-first experience
        for city in cities {
            if let cached = storage.loadWeather(for: city) {
                weatherByCityName[city.name] = cached
            }
        }
        onChange?()

        // 2) Then refresh from network
        refresh()
    }

    func refresh() {
        guard !isLoading else { return }
        isLoading = true

        let group = DispatchGroup()
        var anyNetworkSucceeded = false
        var firstErrorMessage: String?

        for city in cities {
            group.enter()
            apiService.fetchWeather(for: city.name) { [weak self] result in
                defer { group.leave() }
                guard let self else { return }

                switch result {
                case .success(let weather):
                    anyNetworkSucceeded = true
                    self.weatherByCityName[city.name] = weather
                    self.storage.saveWeather(weather, for: city)
                case .failure(let error):
                    // Keep cached value if present; just surface a friendly message.
                    if firstErrorMessage == nil {
                        firstErrorMessage = error.localizedDescription
                    }
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.isLoading = false
            self.onChange?()

            if !anyNetworkSucceeded {
                // If nothing succeeded, most likely offline; cached data (if any) is already shown.
                self.onErrorMessage?("אין חיבור זמין. מוצגים נתונים אחרונים שנשמרו.\n\n\(firstErrorMessage ?? \"\")")
                return
            }

            // Partial failure: some cities loaded, some failed. Show a single friendly message.
            if let firstErrorMessage, !firstErrorMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.onErrorMessage?("חלק מהנתונים לא נטענו.\n\n\(firstErrorMessage)")
            }
        }
    }

    func fetchWeather(for city: City, completion: @escaping () -> Void) {
        apiService.fetchWeather(for: city.name) { [weak self] result in
            guard let self else {
                completion()
                return
            }

            switch result {
            case .success(let weather):
                self.weatherByCityName[city.name] = weather
                self.storage.saveWeather(weather, for: city)
            case .failure(let error):
                if self.weatherByCityName[city.name] == nil, let cached = self.storage.loadWeather(for: city) {
                    self.weatherByCityName[city.name] = cached
                }
                self.onErrorMessage?(error.localizedDescription)
            }

            self.onChange?()
            completion()
        }
    }
}
