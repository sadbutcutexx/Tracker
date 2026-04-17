//
//  AddTrackerConfigurationViewController.swift
//  Tracker
//

import UIKit
import Foundation

final class AddTrackerConfigurationViewController: UIViewController {
    
    // MARK: - Properties

    private let maxNameLength: Int = 38
    private var isLimitReached = false

    private var optionsTopConstraint: NSLayoutConstraint!

    private lazy var categoryRow: UIView = makeSimpleRow(title: "Категория")
    private var selectedDays: [SheduleDaysPicker.WeekDay] = []
    weak var delegate: TrackerScreenProtocol?
    
    // MARK: - Setup Views

    private let limitLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let trackerNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 16
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        return textField
    }()

    private let optionsView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dismissButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Отмена"
        config.baseForegroundColor = .systemRed
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)

        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let createTrackerButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Создать"
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor(white: 0.72, alpha: 1)
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)

        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(createTrackerButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return divider
    }()

    private let scheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scheduleSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Не выбрано"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private let scheduleArrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var scheduleRow: UIView = makeScheduleRow()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryRow, divider, scheduleRow])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var scheduleTitleCenterYConstraint: NSLayoutConstraint!
    private var scheduleTitleTopConstraint: NSLayoutConstraint!
    private var scheduleSubtitleBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecyclee

    override func viewDidLoad() {
        super.viewDidLoad()

        updateCreateButtonState()
        
        view.backgroundColor = .white

        trackerNameField.delegate = self
        trackerNameField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)

        setupConstraints(
            dismissButton: dismissButton,
            createTrackerButton: createTrackerButton,
            titleLabel: titleLabel,
            trackerNameField: trackerNameField,
            optionsView: optionsView,
            limitLabel: limitLabel,
            stack: stack
        )

        updateScheduleRow(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUI()
    }
    
    // MARK: - Private Methods

    private func setupConstraints(
        dismissButton: UIButton,
        createTrackerButton: UIButton,
        titleLabel: UILabel,
        trackerNameField: UITextField,
        optionsView: UIView,
        limitLabel: UILabel,
        stack: UIStackView
    ) {
        view.addSubview(dismissButton)
        view.addSubview(createTrackerButton)
        view.addSubview(titleLabel)
        view.addSubview(trackerNameField)
        view.addSubview(optionsView)
        view.addSubview(limitLabel)
        optionsView.addSubview(stack)

        optionsTopConstraint = optionsView.topAnchor.constraint(equalTo: limitLabel.bottomAnchor, constant: 32)

        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 60),

            createTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createTrackerButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            createTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            createTrackerButton.leadingAnchor.constraint(equalTo: dismissButton.trailingAnchor, constant: 8),
            createTrackerButton.widthAnchor.constraint(equalTo: dismissButton.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            trackerNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),

            limitLabel.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 8),
            limitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            optionsTopConstraint,
            optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: optionsView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor)
        ])
    }

    private func makeSimpleRow(title: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .systemGray3
        arrow.translatesAutoresizingMaskIntoConstraints = false

        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        row.addSubview(titleLabel)
        row.addSubview(arrow)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            arrow.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            arrow.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrow.leadingAnchor, constant: -12)
        ])

        return row
    }

    private func makeScheduleRow() -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(scheduleRowTapped))
        row.addGestureRecognizer(tap)

        row.addSubview(scheduleTitleLabel)
        row.addSubview(scheduleSubtitleLabel)
        row.addSubview(scheduleArrowImageView)

        scheduleTitleCenterYConstraint = scheduleTitleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        scheduleTitleTopConstraint = scheduleTitleLabel.topAnchor.constraint(equalTo: row.topAnchor, constant: 8)
        scheduleSubtitleBottomConstraint = scheduleSubtitleLabel.bottomAnchor.constraint(equalTo: row.bottomAnchor, constant: -8)

        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 60),

            scheduleTitleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            scheduleTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: scheduleArrowImageView.leadingAnchor, constant: -12),

            scheduleSubtitleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            scheduleSubtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: scheduleArrowImageView.leadingAnchor, constant: -12),

            scheduleArrowImageView.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            scheduleArrowImageView.centerYAnchor.constraint(equalTo: row.centerYAnchor)
        ])

        scheduleTitleCenterYConstraint.isActive = true
        return row
    }

    private func resetUI() {
        trackerNameField.text = ""
        limitLabel.text = ""
        limitLabel.isHidden = true
        isLimitReached = false
        optionsTopConstraint.constant = 32
        selectedDays = []
        updateScheduleRow(animated: false)
        view.layoutIfNeeded()
    }

    private func updateScheduleRow(animated: Bool = true) {
        let hasDays = !selectedDays.isEmpty

        scheduleSubtitleLabel.text = hasDays
            ? selectedDays.map { $0.shortName }.joined(separator: ", ")
            : "Не выбрано"

        scheduleSubtitleLabel.isHidden = !hasDays

        scheduleTitleCenterYConstraint.isActive = !hasDays
        scheduleTitleTopConstraint.isActive = hasDays
        scheduleSubtitleBottomConstraint.isActive = hasDays

        let animations = {
            self.view.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: animations)
        } else {
            animations()
        }
    }
    
    private func updateCreateButtonState() {
        let hasText = !(trackerNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let hasDays = !selectedDays.isEmpty

        let isEnabled = hasText && hasDays

        createTrackerButton.isEnabled = isEnabled
        createTrackerButton.configuration?.baseBackgroundColor = isEnabled
            ? .black
            : UIColor.systemGray4

        createTrackerButton.configuration?.baseForegroundColor = .white
    }
    
    // MARK: - Private Actions

    @objc private func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc private func createTrackerButtonDidTapped() {
        view.endEditing(true)

        let tracker = Tracker(
            id: UUID(),
            title: trackerNameField.text ?? "",
            color: .systemBlue,
            emoji: "🙂",
            shedule: selectedDays.map { $0.rawValue }
        )
        
        delegate?.newTrackerAdded(tracker)
        dismiss(animated: true)
    }
    
    @objc private func textDidChanged() {
        let count = trackerNameField.text?.count ?? 0
        let newState = count >= maxNameLength

        guard newState != isLimitReached else { return }
        isLimitReached = newState

        limitLabel.text = "Ограничение 38 символов"
        limitLabel.isHidden = !newState

        optionsTopConstraint.constant = newState ? 24 : 0

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }

        updateCreateButtonState()
    }

    @objc private func scheduleRowTapped() {
        let picker = SheduleDaysPicker()
        picker.selectedDays = selectedDays

        picker.onDaysSelected = { [weak self] days in
            self?.selectedDays = days
            self?.updateScheduleRow()
            self?.updateCreateButtonState()
        }
        
        view.endEditing(true)

        present(picker, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension AddTrackerConfigurationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText)
        else { return false }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        return updatedText.count <= maxNameLength
    }
}
