//
//  ColorCell.swift
//  Tracker
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let reuseIdentifier = "ColorCell"

    private let selectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.isHidden = true
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
        contentView.addSubview(selectionView)
        contentView.addSubview(colorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            selectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }

    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color

        if isSelected {
            selectionView.isHidden = false
            selectionView.backgroundColor = color.withAlphaComponent(0.3)
        } else {
            selectionView.isHidden = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        selectionView.isHidden = true
        colorView.backgroundColor = .clear
    }
}
