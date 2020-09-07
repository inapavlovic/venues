//
//  ActivityViewController.swift
//  vennu
//
//  Created by Ina Statkic on 09/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class ActivityViewController: UIViewController {
    
    // MARK: - Controls
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var activities = [Activity]() {
        didSet {
            child.items = activities
            child.snapshot()
            emptyLabel.isHidden = !activities.isEmpty
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .desertStorm
        setActivityIndicator()
        manageActivities()
        setElements()
    }
    
    // MARK: - Set
    
    private func setActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(frame: view.frame)
        view.addSubview(activityIndicatorView)
    }
    
    // MARK: - Elements
    
    var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .tuna
        label.text = "No activities yet."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let child = CollectionsViewController<Activity, ActivityCell>()
    
    private func setElements() {
        embed(child, into: view) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: $1.safeAreaLayoutGuide.topAnchor, constant: 30),
                $0.leadingAnchor.constraint(equalTo: $1.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: $1.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: $1.bottomAnchor)
            ])
        }
        child.configure = { activity, cell in
            cell.populate(with: activity)
        }
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: emptyLabel.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: emptyLabel.centerYAnchor)
        ])
    }
}

// MARK: - Web Services

extension ActivityViewController {
    private func manageActivities() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.activities {
            self.activityIndicatorView.stopAnimating()
            self.activities = $0.filter { $0.uidVenue == FirebaseManager.shared.uid }
        }
    }
}
