//
//  SearchListViewController.swift
//  users
//
//  Created by Ina Statkic on 27/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class SearchListViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: Outlets
    
    @IBOutlet private weak var searchView: SearchView!
    @IBOutlet private weak var listView: UIView!
    @IBOutlet weak var topSearchViewConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var searchText: String? = ""
    private var venues = [Venue]() {
        didSet {
            child.items = venues
            child.snapshot()
        }
    }

    private var facilities: [Facility] = []
    var numberOfPeople: Int = 25
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setElements()
        setActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigation()
        manageSearchVenues()
        searchView.text = searchText
        searchView.numberOfPeople = numberOfPeople
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        unsetNavigation()
    }
    
    // MARK: - Elements
    
    private let child = CollectionsViewController<Venue, ListCollectionCell>()
    
    private func setElements() {
        embed(child, into: view) { child, parent in
            NSLayoutConstraint.activate([
                child.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 30),
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
        child.scrollUp = {
            self.view.layoutIfNeeded()
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
                self.topSearchViewConstraint.constant = -220
                self.searchView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
        child.scrollDown = {
            self.view.layoutIfNeeded()
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
                self.topSearchViewConstraint.constant = 20
                self.searchView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - Actions
    
    @objc func map() {
        flowController.goToMap(searchText: searchText ?? "", numberOfPeople: numberOfPeople)
    }
    
    private func setActions() {
        searchView.didSearch = { [weak self] _ in
            self?.manageSearchVenues()
        }
        searchView.searching = { [weak self] in
            self?.searchText = $0
        }
        searchView.didArrange = { [weak self] in
            self?.manageSearchVenues()
        }
        searchView.didFilters = { [weak self] in
            self?.flowController.goToFacilities(self?.facilities.map { $0.name })
        }
        searchView.pickNumberOfPeople = { [weak self] in
            self?.numberOfPeople = $0
            self?.manageSearchVenues()
        }
    }

}

// MARK: - Facilities Delegate

extension SearchListViewController: FacilitiesDelegate {
    func facilities(_ vc: FacilitiesViewController, _ facilities: [Facility]) {
        self.facilities = facilities
        manageSearchVenues()
    }
}

// MARK: - Web Services

extension SearchListViewController {
    private func manageSearchVenues() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.locationVenues(query: searchText!) {
            venues in
            self.activityIndicatorView.stopAnimating()
            self.venues = venues
            if !self.facilities.isEmpty {
                self.venues = self.venues.filter {
                    $0.facilities.contains(where: self.facilities.map { $0.name }.contains)
                }
            }
            self.venues = self.venues.filter { $0.capacity.numberOfPeople >= self.numberOfPeople }
            if self.searchView.arrangedByMax {
                self.venues = self.venues.sorted(by: { $0.pricing.hourly < $1.pricing.hourly})
            } else {
                self.venues = self.venues.sorted(by: { $0.pricing.hourly > $1.pricing.hourly})
            }
        }
    }
}

// MARK: - Navigation

extension SearchListViewController {
    private func setNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let image = UIImage(systemName: "map")?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(map))
        navigationItem.rightBarButtonItem?.tintColor = .tuna
    }
    private func unsetNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

