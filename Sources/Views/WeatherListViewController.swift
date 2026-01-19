import UIKit

final class WeatherListViewController: UITableViewController {
    private let viewModel: WeatherListViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    init(viewModel: WeatherListViewModel = WeatherListViewModel()) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        self.viewModel = WeatherListViewModel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Weather"
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseIdentifier)
        tableView.rowHeight = 64

        activityIndicator.hidesWhenStopped = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)

        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        refreshControl = rc

        bindViewModel()
        viewModel.load()
    }

    private func bindViewModel() {
        viewModel.onChange = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onLoadingChanged = { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.refreshControl?.endRefreshing()
            }
        }

        viewModel.onErrorMessage = { [weak self] message in
            guard let self else { return }
            let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            let alert = UIAlertController(title: "Notice", message: trimmed, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    @objc private func didPullToRefresh() {
        viewModel.refresh()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseIdentifier, for: indexPath)

        guard let cityCell = cell as? CityCell else { return cell }

        let city = viewModel.cities[indexPath.row]
        let weather = viewModel.weather(for: city)

        let tempText: String
        if let temp = weather?.temp {
            tempText = "\(Int(temp.rounded()))°C"
        } else {
            tempText = "--"
        }

        cityCell.configure(cityName: city.name, temperatureText: tempText, icon: nil)

        if let icon = weather?.icon, !icon.isEmpty {
            let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            if let url = URL(string: urlString) {
                ImageLoader.shared.load(from: url) { [weak tableView] image in
                    guard let tableView else { return }
                    // Avoid wrong-image issue when cells are reused.
                    if let visibleCell = tableView.cellForRow(at: indexPath) as? CityCell {
                        visibleCell.configure(cityName: city.name, temperatureText: tempText, icon: image)
                    }
                }
            }
        }

        return cityCell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = viewModel.cities[indexPath.row]
        let detailVM = DetailViewModel(city: city)
        let vc = DetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(vc, animated: true)
    }
}
