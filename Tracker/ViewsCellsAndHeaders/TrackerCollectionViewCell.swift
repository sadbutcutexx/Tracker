//
//  TrackerCollectionViewCell.swift
//  Tracker
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "TrackerCollectionViewCell"

    // MARK: - Labels

    private let containerView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()

    private let emojiBackgroundView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()

    private let daysLabel = UILabel()
    private let addButton = UIButton(type: .system)
    
    var onActionTap: (() -> Void)?

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        emojiLabel.text = nil
        titleLabel.text = nil
        daysLabel.text = nil
    }

    // MARK: - Configure

    func configure(
        emoji: String,
        title: String,
        color: UIColor,
        days: Int = 0
    ) {
        emojiLabel.text = emoji
        titleLabel.text = title
        daysLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of days"),
            days
        )

        topView.backgroundColor = color
        addButton.backgroundColor = color
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        // Container
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true

        // Top (colored)
        topView.layer.cornerRadius = 16
        topView.clipsToBounds = true

        // Bottom
        bottomView.backgroundColor = .white

        // Emoji background
        emojiBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        emojiBackgroundView.layer.cornerRadius = 18

        // Emoji
        emojiLabel.font = .systemFont(ofSize: 20)
        emojiLabel.textAlignment = .center

        // Title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2

        // Days
        daysLabel.font = .systemFont(ofSize: 14, weight: .medium)
        daysLabel.textColor = .black

        // Button
        addButton.layer.cornerRadius = 18
        addButton.clipsToBounds = true
        let image = UIImage(systemName: "plus")
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .white
        addButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .regular)
        addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        // Hierarchy
        contentView.addSubview(containerView)
        containerView.addSubview(topView)
        containerView.addSubview(bottomView)

        topView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        topView.addSubview(titleLabel)

        bottomView.addSubview(daysLabel)
        bottomView.addSubview(addButton)
    }

    private func setupConstraints() {
        [
            containerView,
            topView,
            bottomView,
            emojiBackgroundView,
            emojiLabel,
            titleLabel,
            daysLabel,
            addButton
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // Top
            topView.topAnchor.constraint(equalTo: containerView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 105),

            // Bottom
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            // Emoji background
            emojiBackgroundView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 36),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 36),

            // Emoji
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),

            // Title
            titleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -12),

            // Days
            daysLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 12),
            daysLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),

            // Button
            addButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -12),
            addButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 36),
            addButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    func setCompleted(_ completed: Bool) {
        let image = UIImage(systemName: completed ? "checkmark" : "plus")
        addButton.setImage(image, for: .normal)

        let baseColor = topView.backgroundColor ?? .systemBlue

        if completed {
            addButton.backgroundColor = baseColor.withAlphaComponent(0.3)
        } else {
            addButton.backgroundColor = baseColor
        }
    }

    // MARK: - Helpers

    private func formatDays(_ days: Int) -> String {
        switch days % 10 {
        case 1 where days % 100 != 11:
            return "\(days) день"
        case 2...4 where !(12...14).contains(days % 100):
            return "\(days) дня"
        default:
            return "\(days) дней"
        }
    }
    
    func setActionEnabled(_ enabled: Bool) {
        addButton.isEnabled = enabled
        addButton.alpha = enabled ? 1.0 : 0.4
    }
    
    @objc private func buttonTapped() {
        onActionTap?()
    }
}
