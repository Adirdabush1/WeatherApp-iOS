import UIKit

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let detailView = DetailView()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.city.name
        navigationItem.largeTitleDisplayMode = .never

        detailView.refreshButton.addTarget(self, action: #selector(didTapRefresh), for: .touchUpInside)

        bindViewModel()
        viewModel.load()
    }

    private func bindViewModel() {
        viewModel.onChange = { [weak self] in
            guard let self else { return }
            self.detailView.apply(
                cityName: self.viewModel.city.name,
                weather: self.viewModel.weather
            )
        }

        viewModel.onLoadingChanged = { [weak self] isLoading in
            self?.detailView.setLoading(isLoading)
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

    @objc private func didTapRefresh() {
        viewModel.refresh()
    }
}
