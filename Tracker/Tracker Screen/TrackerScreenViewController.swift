//
//  MainScreenViewController.swift
//  Tracker
//

import UIKit

final class TrackerScreenViewController: UIViewController {
    
    // MARK: - Outlets
    
    private var addTrackerButton: UIButton?
    private var datePicker: UIDatePicker?
    private var trackerLabel: UILabel?
    private var searchBar: UISearchBar?
    private var stubImageView: UIImageView?
    private var stubLabel: UILabel?
    private var trackerCollectionView: UICollectionView?
    
    //MARK: - ViewControllers
    
    private var addTrackerViewController: UIViewController = AddTrackerConfigurationViewController()
    
    // MARK: - Properties
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [Tracker] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        
        setupViewsAndConstraints()
    }
    
    // MARK: - Setup Constraints And Views
    
    private func setupConstraints(
        addTrackerButton: UIButton,
        datePicker: UIDatePicker,
        trackerLabel: UILabel,
        searchBar: UISearchBar,
        stubImageView: UIImageView,
        stubLabel: UILabel,
        collectionView: UICollectionView
    ) {
        NSLayoutConstraint.activate([
            
            // addTrackerButton
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            
            // datePicker
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            
            // trackerLabel
            trackerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            trackerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 12),

            // searchBar
            searchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // stubImageView 
            stubImageView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220),
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // stubLabel
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 12),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // trackerCollectionView
            
            
        ])
    }
    
    private func setupViewsAndConstraints() {
        addTrackerButton = createAddTrackerButton()
        datePicker = createDatePicker()
        trackerLabel = createTrackerLabel()
        searchBar = createSearchBar()
        stubImageView = createStubImageView()
        stubLabel = createStubLabel()
        trackerCollectionView = createCollectionView()
        
        guard let addTrackerButton,
              let datePicker,
              let trackerLabel,
              let searchBar,
              let stubImageView,
              let stubLabel,
              let trackerCollectionView else {
            return
        }
        
        [addTrackerButton, datePicker, trackerLabel, searchBar, stubImageView, stubLabel, trackerCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints(
            addTrackerButton: addTrackerButton,
            datePicker: datePicker,
            trackerLabel: trackerLabel,
            searchBar: searchBar,
            stubImageView: stubImageView,
            stubLabel: stubLabel,
            collectionView: trackerCollectionView
        )
        
        view.backgroundColor = UIColor(named: "White [iOS]")
    }
    
    // MARK: - Create Views
    
    private func createAddTrackerButton() -> UIButton {
        let addTrackerButton = UIButton.systemButton(
            with: UIImage(named: "AddTrackersButton") ?? UIImage(),
            target: self,
            action: #selector(Self.addTrackersButtonTapped)
        )
        
        addTrackerButton.tintColor = UIColor(named: "Black [iOS]")
        
        return addTrackerButton
    }
    
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return datePicker
    }
    
    private func createTrackerLabel() -> UILabel {
        let trackerLabel = UILabel()
        
        trackerLabel.text = "Трекеры"
        trackerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerLabel.textColor = UIColor(named: "Black [iOS]")
        
        return trackerLabel
    }
    
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        searchBar.backgroundImage = UIImage()
        searchBar.layer.cornerRadius = 16
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.clear.cgColor
        
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        
        return searchBar
    }
    
    private func createStubImageView() -> UIImageView {
        let stubImageView = UIImageView(image: UIImage(named: "TrackerMainscreenStubImage"))
        
        return stubImageView
    }
    
    private func createStubLabel() -> UILabel {
        let stubLabel = UILabel()
        
        stubLabel.text = "Что будем отслеживать?"
        stubLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        stubLabel.textColor = UIColor(named: "Black [iOS]")
        
        return stubLabel
    }
    
    private func createCollectionView() -> UICollectionView {
        let collectionView: UICollectionView = {
            let collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: UICollectionViewFlowLayout()
            )
            
            collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCollectionCell")
            return collectionView
        }()
        
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
        
        return collectionView
    }
    
    // MARK: - Private Actions
    
    @objc private func addTrackersButtonTapped() {
        self.present(addTrackerViewController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Selected date: \(formattedDate)")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerScreenViewController: UICollectionViewDelegateFlowLayout {
    
}
