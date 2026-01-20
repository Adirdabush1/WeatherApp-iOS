import UIKit

final class SampleDetailViewController: UIViewController {
    private let infoLabel = UILabel()
    private let activity = UIActivityIndicatorView(style: .large)
    private let refreshButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sample Detail"
        setupUI()
    }

    private func setupUI() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.text = "Sample detail content"
        infoLabel.textAlignment = .center

        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true

        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)

        view.addSubview(infoLabel)
        view.addSubview(activity)
        view.addSubview(refreshButton)

        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),

            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),

            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 12)
        ])
    }

    @objc private func refreshTapped() {
        activity.startAnimating()
        // simulate network
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            self.activity.stopAnimating()
            self.infoLabel.text = "Refreshed: \(Date())"
        }
    }
}
