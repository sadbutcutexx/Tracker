//
//  SecondOnboardingScreenViewController.swift
//  Tracker
//

import Foundation
import UIKit

final class SecondOnboardingScreenViewController: UIViewController {
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Onbording_Background_Second"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.text = "Даже если это не литры воды и йога"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(backgroundImage)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            
            label.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -304),
            label.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: backgroundImage.topAnchor, constant: 432)
        ])
    }
}
