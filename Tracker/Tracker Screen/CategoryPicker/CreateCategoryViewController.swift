//
//  CreateCategoryViewController.swift
//  Tracker
//

import UIKit

final class CreateCategoryViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: CategoryViewModel
    
    var onCategoryCreated: (() -> Void)?

    // MARK: - UI

    private let textField: UITextField = {
        let tf = UITextField()

        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Введите название категории"
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        tf.leftViewMode = .always

        return tf
    }()

    private lazy var readyButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = .systemGray3
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(
            self,
            action: #selector(readyTapped),
            for: .touchUpInside
        )

        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: - Init

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.addTarget(
            self,
            action: #selector(textDidChange),
            for: .editingChanged
        )

        view.backgroundColor = .white

        navigationItem.title = "Новая категория"

        view.addSubview(textField)
        view.addSubview(readyButton)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            
            // TitleLabel
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // TextField
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),

            // ReadyButton
            
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Actions

    @objc private func readyTapped() {
        guard let text = textField.text, !text.isEmpty else { return }

        viewModel.createCategory(title: text)

        onCategoryCreated?()
        dismiss(animated: true)
    }
    
    @objc private func textDidChange() {

        let isValid = !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)

        readyButton.isEnabled = isValid

        readyButton.backgroundColor = isValid
            ? .black
            : .systemGray3
    }
}
