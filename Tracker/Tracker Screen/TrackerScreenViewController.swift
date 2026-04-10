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
    
    // MARK: - Properties
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [Tracker] = []

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndConstraints()
    }
    
    // MARK: - Setup Constraints And Views
    
    private func setupConstraints(
        addTrackerButton: UIButton,
        datePicker: UIDatePicker,
        trackerLabel: UILabel,
        searchBar: UISearchBar,
        stubImageView: UIImageView,
        stubLabel: UILabel
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
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupViewsAndConstraints() {
        addTrackerButton = createAddTrackerButton()
        datePicker = createDatePicker()
        trackerLabel = createTrackerLabel()
        searchBar = createSearchBar()
        stubImageView = createStubImageView()
        stubLabel = createStubLabel()
        
        guard let addTrackerButton,
              let datePicker,
              let trackerLabel,
              let searchBar,
              let stubImageView,
              let stubLabel else {
            return
        }
        
        [addTrackerButton, datePicker, trackerLabel, searchBar, stubImageView, stubLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints(
            addTrackerButton: addTrackerButton,
            datePicker: datePicker,
            trackerLabel: trackerLabel,
            searchBar: searchBar,
            stubImageView: stubImageView,
            stubLabel: stubLabel
        )
        
        view.backgroundColor = UIColor(named: "White [iOS]")
    }
    
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
    
    // MARK: - Private Actions
    
    @objc private func addTrackersButtonTapped() {
        // TODO: - Code
    }
}
