import UIKit

class CityCell: UITableViewCell {
    static let reuseIdentifier = "CityCell"

    private let iconImageView = UIImageView()
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        cityLabel.text = nil
        tempLabel.text = nil
    }

    func configure(cityName: String, temperatureText: String, icon: UIImage?) {
        cityLabel.text = cityName
        tempLabel.text = temperatureText
        iconImageView.image = icon
    }

    private func setupUI() {
        selectionStyle = .default

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .secondaryLabel
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        cityLabel.textColor = .label

        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
        tempLabel.textColor = .secondaryLabel
        tempLabel.textAlignment = .right
        tempLabel.setContentHuggingPriority(.required, for: .horizontal)
        tempLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        contentView.addSubview(iconImageView)
        contentView.addSubview(cityLabel)
        contentView.addSubview(tempLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            cityLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            tempLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cityLabel.trailingAnchor, constant: 12),
            tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
