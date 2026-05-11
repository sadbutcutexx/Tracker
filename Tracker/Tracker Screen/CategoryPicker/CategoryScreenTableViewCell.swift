import UIKit

final class CategoryScreenTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CategoryScreenTableViewCell"

    // MARK: - UI

    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = UIFont.systemFont(
            ofSize: 17,
            weight: .regular
        )

        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {

        backgroundColor = .white
        contentView.backgroundColor = .white
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([

            // Container

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.heightAnchor.constraint(equalToConstant: 75),

            // Title

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            // Checkmark

            checkmarkImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // MARK: - Configure

    func configure(title: String, isSelected: Bool) {

        titleLabel.text = title

        checkmarkImageView.isHidden = !isSelected
    }
}
