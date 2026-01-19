import UIKit

class DetailView: UIView {
    let refreshButton = UIButton(type: .system)

    private let iconImageView = UIImageView()
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let minMaxLabel = UILabel()
    private let humidityLabel = UILabel()
    private let windLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            refreshButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            refreshButton.isEnabled = true
        }
    }

    func apply(cityName: String, weather: Weather?) {
        cityLabel.text = cityName

        guard let weather else {
            tempLabel.text = "--"
            minMaxLabel.text = ""
            humidityLabel.text = ""
            windLabel.text = ""
            iconImageView.image = nil
            return
        }

        tempLabel.text = "\(Int(weather.temp.rounded()))°C"
        minMaxLabel.text = "Min: \(Int(weather.tempMin.rounded()))°C  |  Max: \(Int(weather.tempMax.rounded()))°C"
        humidityLabel.text = "Humidity: \(weather.humidity)%"
        windLabel.text = "Wind: \(String(format: "%.1f", weather.windSpeed)) m/s"

        if !weather.icon.isEmpty {
            let urlString = "https://openweathermap.org/img/wn/\(weather.icon)@2x.png"
            if let url = URL(string: urlString) {
                ImageLoader.shared.load(from: url) { [weak self] image in
                    self?.iconImageView.image = image
                }
            }
        } else {
            iconImageView.image = nil
        }
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        cityLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        cityLabel.textColor = .label

        tempLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)
        tempLabel.textColor = .label

        minMaxLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        minMaxLabel.textColor = .secondaryLabel

        humidityLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        humidityLabel.textColor = .secondaryLabel

        windLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        windLabel.textColor = .secondaryLabel

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .secondaryLabel

        refreshButton.setTitle("רענן", for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        activityIndicator.hidesWhenStopped = true

        let stack = UIStackView(arrangedSubviews: [
            cityLabel,
            iconImageView,
            tempLabel,
            minMaxLabel,
            humidityLabel,
            windLabel,
            refreshButton,
            activityIndicator
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center

        stack.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),

            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
