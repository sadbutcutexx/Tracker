//
//  Untitled.swift
//  Tracker
//

import UIKit
import Foundation

final class CategoryTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let rightArrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = NSLocalizedString("category", comment: "Category")
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .label
        
        subtitleLabel.text = "Домашний уют"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray
        
        rightArrowImageView.tintColor = .systemGray3
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(rightArrowImageView)
        
        NSLayoutConstraint.activate([
            // 1. titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            // 2. subtitleLabel
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // 3. rightArrowImageView
            rightArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightArrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with categoryName: String?) {
        subtitleLabel.text = categoryName
    }
}
