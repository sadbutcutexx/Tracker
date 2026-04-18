//
//  AddTrackerConfigurationViewController.swift
//  Tracker
//


import UIKit

final class AddTrackerConfigurationViewController: UIViewController {

    // MARK: - Properties

    private let maxNameLength: Int = 38
    private var isLimitReached = false

    private let defaultCategory = "Домашний уют"
    weak var delegate: TrackerScreenProtocol?

    private var tableView: UITableView!
    private var selectedDays: [SheduleDaysPicker.WeekDay] = []

    // MARK: - UI Elements

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

    private let dismissButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Отменить"
        config.baseForegroundColor = .systemRed
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)

        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self,
                         action: #selector(dismissButtonTapped),
                         for: .touchUpInside)
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
        button.addTarget(self,
                         action: #selector(createTrackerButtonDidTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateCreateButtonState()
        view.backgroundColor = .white

        trackerNameField.delegate = self
        trackerNameField.addTarget(self,
                                   action: #selector(textDidChanged),
                                   for: .editingChanged)

        configureTableView()

        setupConstraints(dismissButton: dismissButton,
                         createTrackerButton: createTrackerButton,
                         titleLabel: titleLabel,
                         trackerNameField: trackerNameField,
                         limitLabel: limitLabel,
                         tableView: tableView)
    }

    // MARK: - Configure TableView

    private func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .systemGray6
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = 75

        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleCell")

        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Setup Constraints

    private func setupConstraints(
        dismissButton: UIButton,
        createTrackerButton: UIButton,
        titleLabel: UILabel,
        trackerNameField: UITextField,
        limitLabel: UILabel,
        tableView: UITableView
    ) {
        view.addSubview(dismissButton)
        view.addSubview(createTrackerButton)
        view.addSubview(titleLabel)
        view.addSubview(trackerNameField)
        view.addSubview(limitLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 60),

            createTrackerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createTrackerButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
            createTrackerButton.heightAnchor.constraint(equalTo: dismissButton.heightAnchor),
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

            tableView.topAnchor.constraint(equalTo: limitLabel.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    // MARK: - Private Methods

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

    // MARK: - Actions

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

        delegate?.newTrackerAdded(tracker, categoryTitle: defaultCategory)

        dismiss(animated: true)
    }

    @objc private func textDidChanged() {
        let count = trackerNameField.text?.count ?? 0
        let newState = count >= maxNameLength

        guard newState != isLimitReached else {
            updateCreateButtonState()
            return
        }

        isLimitReached = newState
        limitLabel.text = "Ограничение 38 символов"
        limitLabel.isHidden = !newState

        updateCreateButtonState()
    }

    @objc private func scheduleRowTapped() {
        let picker = SheduleDaysPicker()
        picker.selectedDays = selectedDays

        picker.onDaysSelected = { [weak self] days in
            self?.selectedDays = days
            self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
            self?.updateCreateButtonState()
        }

        view.endEditing(true)
        present(picker, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AddTrackerConfigurationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return tableView
                .dequeueReusableCell(
                    withIdentifier: "CategoryCell",
                    for: indexPath
                ) as! CategoryTableViewCell

        case 1:
            let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: "ScheduleCell",
                    for: indexPath
                ) as! ScheduleTableViewCell
            cell.configure(with: selectedDays)
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate

extension AddTrackerConfigurationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == rows - 1 {
            cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer { tableView.deselectRow(at: indexPath, animated: true) }

        switch indexPath.row {
        case 1:
            scheduleRowTapped()

        case 0:
            break

        default:
            break
        }
    }
}

// MARK: - UITextFieldDelegate

extension AddTrackerConfigurationViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText)
        else { return false }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        return updatedText.count <= maxNameLength
    }
}
