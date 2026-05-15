//
//  MainScreenViewController.swift
//  Tracker
//

import UIKit

protocol TrackerScreenProtocol: AnyObject {
    func newTrackerAdded(_ tracker: Tracker, categoryTitle: String)
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
    
    //MARK: - Properties
    
    private var searchText: String = ""
    private var currentDate: Date = Date()
    private var completedTrackers: [TrackerRecord] = []
    
    private var categories: [TrackerCategory] {
        TrackerStore.shared.getCategories()
    }
    
    // MARK: - Fillter
    
    private var displayedCategories: [TrackerCategory] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TrackerStore.shared.delegate = self
        setupViewsAndConstraints()
        completedTrackers = TrackerRecordStore.shared.loadRecords()
        
        try? TrackerStore.shared.performFetch()
        updateData()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
            
            trackerCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - Create Views
    
    private func createAddTrackerButton() -> UIButton {
        let button = UIButton.systemButton(
            with: UIImage(named: "AddTrackersButton") ?? UIImage(),
            target: self,
            action: #selector(addTrackersButtonTapped)
        )
        button.tintColor = UIColor(named: "Black [iOS]")
        return button
    }
    
    private func createDatePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale.current
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return picker
    }
    
    private func createTrackerLabel() -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("trackers", comment: "Trackers")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "Black [iOS]")
        return label
    }
    
    private func createSearchBar() -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = NSLocalizedString("search", comment: "Search")
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
    private func createStubImageView() -> UIImageView {
        UIImageView(image: UIImage(named: "TrackerMainscreenStubImage"))
    }
    
    private func createStubLabel() -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("what_shall_we_track", comment: "What shall we track")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black [iOS]")
        return label
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: -1, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier
        )
        
        collectionView.register(
            CategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryHeaderView.reuseIdentifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }
    
    // MARK: - Private Methods
    
    private func updateData() {
        let allCategories = TrackerStore.shared.getCategories()

        let filtered = allCategories.compactMap { category -> TrackerCategory? in
            let trackers = category.trackers.filter { tracker in
                let matchesSearch =
                    searchText.isEmpty ||
                    tracker.title.lowercased().contains(searchText.lowercased())

                let matchesDate = isTrackerVisible(tracker)

                return matchesSearch && matchesDate
            }

            return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
        }

        displayedCategories = filtered

        trackerCollectionView?.reloadData()
        updateEmptyState()
    }
    
    private func isTrackerVisible(_ tracker: Tracker) -> Bool {
        if tracker.shedule.isEmpty {
            return true
        }
        
        let weekday = weekdayNormalized(from: currentDate)
        return tracker.shedule.contains(weekday)
    }
    
    private func weekdayNormalized(from date: Date) -> Int {
        let weekday = Calendar.current.component(.weekday, from: date)
        return weekday == 1 ? 7 : weekday
    }
    
    // MARK: - Add Tracker
    
    func newTrackerAdded(_ tracker: Tracker, categoryTitle: String) {
        do {
            try TrackerStore.shared.saveTracker(trackerModel: tracker, categoryTitle: categoryTitle)
        } catch {
            let errorLocalized = NSLocalizedString("save_error", comment: "Save error!")
            print("\(errorLocalized)\(error.localizedDescription)")
        }
    }

    
    // MARK: - Empty State
    
    private func updateEmptyState() {
        
        let hasTrackers = !displayedCategories.isEmpty

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
    // MARK: - onDateToggle
    
    private func normalizedDate(_ date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
    
    private func weekday(from date: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: date)
    }
    
    private func isCompleted(_ tracker: Tracker) -> Bool {
        let key = dateKey(currentDate)
        return completedTrackers.contains { $0.trackerId == tracker.id && $0.date == key }
    }
    
    private func toggleTracker(_ tracker: Tracker) {
        let key = dateKey(currentDate)

        if isCompleted(tracker) {
            try? TrackerRecordStore.shared.removeRecord(
                trackerId: tracker.id,
                dateString: key
            )
        } else {
            try? TrackerRecordStore.shared.addRecord(
                trackerId: tracker.id,
                dateString: key
            )
        }

        completedTrackers = TrackerRecordStore.shared.loadRecords()
        trackerCollectionView?.reloadData()
    }
    
    private func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Private Actions
    
    @objc private func addTrackersButtonTapped() {
        let vc = AddTrackerConfigurationViewController()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        updateData()
    }
}

// MARK: - UISearchBarDelegate

extension TrackerScreenViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        updateData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchText = ""
        searchBar.resignFirstResponder()
        trackerCollectionView?.reloadData()
        updateEmptyState()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerScreenViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return displayedCategories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return displayedCategories[section].trackers.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCollectionViewCell else {
            return UICollectionViewCell()
        }

        let category = displayedCategories[indexPath.section]
        let tracker = category.trackers[indexPath.item]
        let days = completedTrackers.filter { $0.trackerId == tracker.id }.count
        
        cell.configure(
            emoji: tracker.emoji,
            title: tracker.title,
            color: tracker.color,
            days: days
        )

        cell.setCompleted(isCompleted(tracker))
        
        let today = Calendar.current.startOfDay(for: Date())
        let selected = Calendar.current.startOfDay(for: currentDate)

        let isFuture = selected > today
        cell.setActionEnabled(!isFuture)
        
        cell.onActionTap = { [weak self] in
                guard let self else { return }
                self.toggleTracker(tracker)
            }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CategoryHeaderView.reuseIdentifier,
            for: indexPath
        ) as? CategoryHeaderView else {
            return UICollectionReusableView()
        }

        let category = displayedCategories[indexPath.section]
        header.configure(title: category.title)

        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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

extension TrackerScreenViewController: TrackerStoreDelegate {
    func trackerCoreDataDidChange(_ store: TrackerStore) {
        updateData()
    }
}
