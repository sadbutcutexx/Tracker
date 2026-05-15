//
//  TabBarController.swift
//  Tracker
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabs()
        addSeporatorLineAboveTabBar()
    }
    
    // MARK: - Configure Tabs
    
    private func configureTabs() {
        let trackerTab = UINavigationController(rootViewController: TrackerScreenViewController())
        let statisticTab = UINavigationController(rootViewController: StatisticVewController())
        
        trackerTab.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", comment: "Trackers"),
            image: UIImage(named: "TrackerTabBarIcon"),
            tag: 0
        )
        
        statisticTab.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", comment: "Statistics"),
            image: UIImage(named: "StatisticTabBarIcon"),
            tag: 1
        )
        
        viewControllers = [trackerTab, statisticTab]
    }
    
    // MARK: - Add Seporation
    
    private func addSeporatorLineAboveTabBar() {
        let seporator = UIView()
        seporator.backgroundColor = UIColor(named: "Gray [iOS]") ?? .systemGray4
        seporator.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(seporator, aboveSubview: tabBar)

        NSLayoutConstraint.activate([
            seporator.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            seporator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seporator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seporator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
