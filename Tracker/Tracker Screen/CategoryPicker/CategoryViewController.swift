//
//  CategoryViewController.swift
//  Tracker
//

import UIKit

final class CategoryViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: CategoryViewModel

    var onCategoryPicked: ((String) -> Void)?

    // MARK: - UI
    
    private let stubImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(named: "TrackerMainscreenStubImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true

        return imageView
    }()
    
    private let stubLabel: UILabel = {
        let label = UILabel()

        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.numberOfLines = 0
        label.textAlignment = .center

        label.font = UIFont.systemFont(
            ofSize: 12,
            weight: .medium
        )

        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true

        return label
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)

        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.separatorStyle = .none
        table.rowHeight = 75
        table.showsVerticalScrollIndicator = false

        table.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )

        table.dataSource = self
        table.delegate = self

        table.register(
            CategoryScreenTableViewCell.self,
            forCellReuseIdentifier: CategoryScreenTableViewCell.reuseIdentifier
        )

        return table
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16

        button.addTarget(
            self,
            action: #selector(addButtonTapped),
            for: .touchUpInside
        )

        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
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

        setupUI()
        bind()
        updateEmptyState()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)

        NSLayoutConstraint.activate([

            // Title

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // TableView

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),

            // Button

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            
            // StubImage
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -40),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),

            // StubLabel
            
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor,constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    // MARK: - Binding

    private func bind() {

        viewModel.onCategoriesChanged = { [weak self] in
            guard let self else { return }
            
            self.tableView.reloadData()
            updateEmptyState()
        }

        viewModel.onCategorySelected = { [weak self] title in
            guard let self else { return }
            
            self.onCategoryPicked?(title)
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        let vc = CreateCategoryViewController(viewModel: viewModel)

        vc.onCategoryCreated = { [weak self] in
            self?.viewModel.fetchCategories()
        }

        present(vc, animated: true)
    }
    
    // Private Methods
    
    private func updateEmptyState() {

        let isEmpty = viewModel.categories.isEmpty

        stubImageView.isHidden = !isEmpty
        stubLabel.isHidden = !isEmpty

        tableView.isHidden = isEmpty
    }
}

extension CategoryViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.categories.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryScreenTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! CategoryScreenTableViewCell

        let category = viewModel.categories[indexPath.row]

        let isSelected = category.title == viewModel.selectedCategory

        cell.configure(title: category.title, isSelected: isSelected)

        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        viewModel.selectCategory(at: indexPath.row)

        tableView.reloadRows(
            at: tableView.indexPathsForVisibleRows ?? [],
            with: .none
        )
    }
}
