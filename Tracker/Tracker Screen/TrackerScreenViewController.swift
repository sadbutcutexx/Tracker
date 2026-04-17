//
//  MainScreenViewController.swift
//  Tracker
//

import UIKit

protocol TrackerScreenProtocol: AnyObject {
    func newTrackerAdded(_ tracker: Tracker)
}

final class TrackerScreenViewController: UIViewController, TrackerScreenProtocol {

    // MARK: - Views

    private var addTrackerButton: UIButton?
    private var datePicker: UIDatePicker?
    private var trackerLabel: UILabel?
    private var searchBar: UISearchBar?
    private var stubImageView: UIImageView?
    private var stubLabel: UILabel?
    private var trackerCollectionView: UICollectionView?

    // MARK: - Categories

    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Домашний уют", trackers: []),
        TrackerCategory(title: "Здоровье", trackers: []),
        TrackerCategory(title: "Работа", trackers: [])
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        setupViewsAndConstraints()
        updateEmptyState()
    }

    // MARK: - Helpers

    private var nonEmptyCategories: [TrackerCategory] {
        categories.filter { !$0.trackers.isEmpty }
    }

    // MARK: - Setup

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

        [addTrackerButton, datePicker, trackerLabel, searchBar, stubImageView, stubLabel, trackerCollectionView]
            .forEach {
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
            trackerCollectionView: trackerCollectionView
        )

        view.backgroundColor = UIColor(named: "White [iOS]")
    }

    private func setupConstraints(
        addTrackerButton: UIButton,
        datePicker: UIDatePicker,
        trackerLabel: UILabel,
        searchBar: UISearchBar,
        stubImageView: UIImageView,
        stubLabel: UILabel,
        trackerCollectionView: UICollectionView
    ) {
        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),

            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),

            trackerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            trackerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 12),

            searchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            stubImageView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220),
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),

            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 12),
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            trackerCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 32),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
            
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
            
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }

    // MARK: - Add Tracker

    func newTrackerAdded(_ tracker: Tracker) {

        let randomIndex = Int.random(in: 0..<categories.count)

        let wasEmpty = categories[randomIndex].trackers.isEmpty

        categories[randomIndex].trackers.append(tracker)

        if wasEmpty {
            trackerCollectionView?.reloadData()
        } else {

            guard let sectionIndex = nonEmptyCategories.firstIndex(where: {
                $0.title == categories[randomIndex].title
            }) else {
                trackerCollectionView?.reloadData()
                return
            }

            let itemIndex = categories[randomIndex].trackers.count - 1
            let indexPath = IndexPath(item: itemIndex, section: sectionIndex)

            trackerCollectionView?.performBatchUpdates {
                trackerCollectionView?.insertItems(at: [indexPath])
            }
        }

        updateEmptyState()
    }

    // MARK: - Empty state

    private func updateEmptyState() {

        let hasTrackers = categories.contains { !$0.trackers.isEmpty }

        stubImageView?.isHidden = hasTrackers
        stubLabel?.isHidden = hasTrackers
        trackerCollectionView?.isHidden = !hasTrackers

        if hasTrackers {
            view.bringSubviewToFront(trackerCollectionView!)
        } else {
            view.bringSubviewToFront(stubImageView!)
            view.bringSubviewToFront(stubLabel!)
        }
    }

    // MARK: - Actions

    @objc private func addTrackersButtonTapped() {
        let vc = AddTrackerConfigurationViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Selected date: \(formattedDate)")
    }
}

// MARK: - DataSource

extension TrackerScreenViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        nonEmptyCategories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        nonEmptyCategories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }

        let category = nonEmptyCategories[indexPath.section]
        let tracker = category.trackers[indexPath.item]

        cell.configure(
            emoji: tracker.emoji,
            title: tracker.title,
            color: tracker.color
        )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CategoryHeaderView.reuseIdentifier,
            for: indexPath
        ) as? CategoryHeaderView else {
            return UICollectionReusableView()
        }

        let category = nonEmptyCategories[indexPath.section]
        header.configure(title: category.title)

        return header
    }
}

// MARK: - Layout

extension TrackerScreenViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let spacing: CGFloat = 12
        let insets: CGFloat = 16 * 2
        let width = (collectionView.bounds.width - insets - spacing) / 2

        return CGSize(width: width, height: 148)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        CGSize(width: collectionView.bounds.width, height: 50)
    }
}
