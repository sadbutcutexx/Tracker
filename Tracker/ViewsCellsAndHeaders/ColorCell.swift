//
//  ColorCell.swift
//  Tracker
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCell"

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0
        view.clipsToBounds = true
        return view
    }()

    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            colorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6),
        ])
    }

    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color

        if isSelected {
            containerView.layer.borderWidth = 3
            containerView.layer.borderColor = color.withAlphaComponent(0.35).cgColor
        } else {
            containerView.layer.borderWidth = 0
            containerView.layer.borderColor = nil
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        colorView.backgroundColor = .clear
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = nil
    }
}
