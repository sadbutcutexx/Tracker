//
//  Untitled.swift
//  Tracker
//

import Foundation
import UIKit

final class ScheduleTableViewCell: UITableViewCell {

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

        titleLabel.text = "Расписание"
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .label

        subtitleLabel.text = "Не выбрано"
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .right

        rightArrowImageView.tintColor = .systemGray3

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(rightArrowImageView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightArrowImageView.leadingAnchor, constant: -12),

            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightArrowImageView.leadingAnchor, constant: -12),

            rightArrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightArrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with selectedDays: [SheduleDaysPicker.WeekDay]) {
        let hasDays = !selectedDays.isEmpty
        let isEveryDay = selectedDays.count == 7

        subtitleLabel.text = {
            if isEveryDay {
                return "Ежедневно"
            } else if hasDays {
                return selectedDays.map { $0.shortName }.joined(separator: ", ")
            } else {
                return "Не выбрано"
            }
        }()

        subtitleLabel.textColor = .systemGray
    }
}
