//
//  OnboardingViewController.swift
//  Tracker
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private let skipButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = NSLocalizedString("onboarding_skip_button", comment: "Now that's technology!")
        config.baseBackgroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self,
                         action: #selector(skipButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if onboardingShownCheck() {
            tabBarRedirect()
        }
        
        addChild(pageViewController)
        
        view.addSubview(pageViewController.view)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            skipButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        pageViewController.didMove(toParent: self)
    }
    
    private func onboardingShownCheck() -> Bool {
        return UserDefaults.standard.bool(forKey: "onboardingShown")
    }
    
    private func tabBarRedirect() {
        let tabBarVC = TabBarController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = tabBarVC
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    @objc private func skipButtonTapped() {
        UserDefaults.standard.set(true, forKey: "onboardingShown")
        
        tabBarRedirect()
    }}
