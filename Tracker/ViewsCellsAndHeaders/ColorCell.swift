//
//  ColorCell.swift
//  Tracker
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCell"

    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
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
        contentView.layer.masksToBounds = false
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.addSubview(colorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        contentView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
        contentView.layer.borderWidth = isSelected ? 2 : 1
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        colorView.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 1
    }
}
