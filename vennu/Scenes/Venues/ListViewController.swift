//
//  ListViewController.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class ListViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var welcomeView: UIView!
    
    // MARK: - Properties
    
    var venues = [Venue]() {
        didSet {
            child.items = venues
            child.snapshot()
            welcomeView.isHidden = !venues.isEmpty
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        manageVenues()
        setElements()
    }
    
    // MARK: - Elements
    
    private let child = CollectionsViewController<Venue, ListCollectionCell>()
    
    private func setElements() {
        embed(child, into: view) { child, parent in
            NSLayoutConstraint.activate([
                child.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 20),
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
            ])
        }
        child.configure = { venue, cell in
            cell.populate(with: venue)
        }
        child.didSelect = {
            self.flowController.goToRoomDetail(venue: $0)
        }
    }
    
    // MARK: - Actions
    
    @objc private func addVenue() {
        flowController.goToAddVenue(nil)
    }

}

// MARK: - Web Services

extension ListViewController {
    private func manageVenues() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.userVenues { venues in
            self.activityIndicatorView.stopAnimating()
            self.venues = venues
        }
    }
}

// MARK: - Navigation

extension ListViewController {
    private func setNavigation() {
        let plusCircle = UIImage(named: "plus.circle")
        let addButtonItem = UIBarButtonItem(image: plusCircle, style: .plain, target: self, action: #selector(addVenue))
        navigationItem.rightBarButtonItem = addButtonItem
    }
}
