import UIKit

final class TestHostViewController: UIViewController {
    private let openListButton = UIButton(type: .system)
    private let openDetailButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Test Screens"
        setupButtons()
    }

    private func setupButtons() {
        openListButton.setTitle("Open Weather List", for: .normal)
        openListButton.addTarget(self, action: #selector(openWeatherList), for: .touchUpInside)

        openDetailButton.setTitle("Open Sample Detail", for: .normal)
        openDetailButton.addTarget(self, action: #selector(openSampleDetail), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [openListButton, openDetailButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func openWeatherList() {
        let vc = WeatherListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openSampleDetail() {
        let vc = SampleDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
