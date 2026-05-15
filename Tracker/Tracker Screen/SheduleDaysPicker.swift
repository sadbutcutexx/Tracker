//
//  SheduleDaysPicker.swift
//  Tracker
//

import UIKit
import Foundation

final class SheduleDaysPicker: UIViewController {
    
    // MARK: - Properties
    
    private var daySwitches: [(day: WeekDay, toggle: UISwitch)] = []
    var onDaysSelected: (([WeekDay]) -> Void)?
    var selectedDays: [WeekDay] = []
    
    enum WeekDay: Int, CaseIterable {
        case sunday = 1
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday

        var fullName: String {
            switch self {
            case .monday: return NSLocalizedString("monday", comment: "Monday")
            case .tuesday: return NSLocalizedString("tuesday", comment: "Tuesday")
            case .wednesday: return NSLocalizedString("wednesday", comment: "Wednesday")
            case .thursday: return NSLocalizedString("thursday", comment: "Thursday")
            case .friday: return NSLocalizedString("friday", comment: "Friday")
            case .saturday: return NSLocalizedString("saturday", comment: "Saturday")
            case .sunday: return NSLocalizedString("sunday", comment: "Sunday")
            }
        }

        var shortName: String {
            switch self {
            case .monday: return NSLocalizedString("monday_short", comment: "Mon")
            case .tuesday: return NSLocalizedString("tuesday_short", comment: "Tue")
            case .wednesday: return NSLocalizedString("wednesday_short", comment: "Wed")
            case .thursday: return NSLocalizedString("thursday_short", comment: "Thu")
            case .friday: return NSLocalizedString("friday_short", comment: "Fri")
            case .saturday: return NSLocalizedString("saturday_short", comment: "Sat")
            case .sunday: return NSLocalizedString("sunday_short", comment: "Sun")
            }
        }
    }
    
    private let days = WeekDay.allCases
    
    // MARK: - Setup Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("schedule", comment: "Schedule")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let readyButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = NSLocalizedString("done", comment: "Done")
        config.baseBackgroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(readyButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    // mARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        view.addSubview(readyButton)

        let rows = days.enumerated().map { index, day in
            makeDayRow(day: day, isLast: index == days.count - 1)
        }

        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: containerView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func makeDayRow(day: WeekDay, isLast: Bool) -> UIView {
        let label = UILabel()
        label.text = day.fullName
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .blue
        toggle.isOn = selectedDays.contains(day)
        daySwitches.append((day: day, toggle: toggle))

        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.translatesAutoresizingMaskIntoConstraints = false

        row.addSubview(label)
        row.addSubview(toggle)
        row.addSubview(divider)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 72),

            label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            toggle.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -20),
            toggle.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            divider.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -20),
            divider.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])

        if isLast {
            divider.isHidden = true
        }

        return row
    }

    @objc private func readyButtonDidTapped(_ sender: UIButton) {
        let selectedDays = daySwitches
            .filter { $0.toggle.isOn }
            .map { $0.day }

        onDaysSelected?(selectedDays)
        dismiss(animated: true)
    }
}
    
