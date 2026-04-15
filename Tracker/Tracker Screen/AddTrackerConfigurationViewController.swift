//
//  AddTrackerConfigurationViewController.swift
//  Tracker
//

import UIKit
import Foundation

final class AddTrackerConfigurationViewController: UIViewController {
    
    // MARK: - Create Labels
    
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
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 16
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let optionsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupConstraints(
            dismissButton: dismissButton,
            createTrackerButton: createTrackerButton,
            titleLabel: titleLabel,
            trackerNameField: trackerNameField,
            optionsView: optionsView
        )
        
        let categoryRow = makeRow(title: "Категория")
        let scheduleRow = makeRow(title: "Расписание")

        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let stack = UIStackView(arrangedSubviews: [categoryRow, divider, scheduleRow])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false

        optionsView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: optionsView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: optionsView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: optionsView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: optionsView.trailingAnchor),
        ])
    }
    
    //MARK: - Private Methods
    
    private func setupConstraints(
        dismissButton: UIButton,
        createTrackerButton: UIButton,
        titleLabel: UILabel,
        trackerNameField: UITextField,
        optionsView: UIView
    ) {
        
        view.addSubview(dismissButton)
        view.addSubview(createTrackerButton)
        view.addSubview(titleLabel)
        view.addSubview(trackerNameField)
        view.addSubview(optionsView)
        
        NSLayoutConstraint.activate([
            // dismissButton
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 60),
            
            // createTrackerButton
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

            optionsView.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 24),
            optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func makeRow(title: String) -> UIView {
        let label = UILabel()
        label.text = title
        
        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .systemGray3
        
        let row = UIView()
        
        row.addSubview(label)
        row.addSubview(arrow)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            arrow.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            arrow.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            
            row.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return row
    }
    
    // MARK: - Private Actions
    
    @objc private func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func createTrackerButtonDidTapped(_ sender: UIButton) {
        // TODO: - Code
    }
}
