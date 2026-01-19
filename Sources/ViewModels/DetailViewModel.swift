import Foundation

class DetailViewModel {
    let city: City
    private let apiService: APIService
    private let storage: LocalStorage

    private(set) var weather: Weather?

    var onChange: (() -> Void)?
    var onErrorMessage: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?

    private var isLoading: Bool = false {
        didSet { onLoadingChanged?(isLoading) }
    }

    init(city: City, apiService: APIService = APIService(), storage: LocalStorage = LocalStorage()) {
        self.city = city
        self.apiService = apiService
        self.storage = storage
    }

    func load() {
        // Offline-first: load cache immediately
        if let cached = storage.loadWeather(for: city) {
            weather = cached
            onChange?()
        }
        refresh()
    }

    func refresh() {
        guard !isLoading else { return }
        isLoading = true

        apiService.fetchWeather(for: city.name) { [weak self] result in
            guard let self else { return }
            self.isLoading = false

            switch result {
            case .success(let weather):
                self.weather = weather
                self.storage.saveWeather(weather, for: self.city)
                self.onChange?()
            case .failure(let error):
                if self.weather == nil, let cached = self.storage.loadWeather(for: self.city) {
                    self.weather = cached
                    self.onChange?()
                }
                self.onErrorMessage?("אין חיבור זמין. מוצגים נתונים אחרונים שנשמרו.\n\n\(error.localizedDescription)")
            }
        }
    }

    func refresh(completion: @escaping () -> Void) {
        refresh()
        completion()
    }
}
