//
//  VenueDetailsViewController.swift
//  vennu
//
//  Created by Ina Statkic on 13/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import MapKit

enum VenueDetailsContext {
    case listing
    case book
    case startedVenue
    case pastBooking
    case upcomingBooking
}

final class VenueDetailsViewController: UIViewController {
    
    // MARK: Flow
    
    lazy var flowController = RoomDetailFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionView: DescriptionView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var featuresView: UIView!
    @IBOutlet private weak var capacityView: UIView!
    @IBOutlet private weak var facilitiesView: UIView!
    @IBOutlet private weak var pricingView: UIView!
    @IBOutlet private weak var featuresViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var capacityViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var facilitiesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pricingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var reviewsView: UIView!
    @IBOutlet private weak var reviewCountLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var callToAction: UIButton!
    @IBOutlet weak var cta: UIButton!
    @IBOutlet weak var reviewsHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var venue: Venue! {
        didSet {
            reviewsChild.items = venue.reviews
            if venue.rates.contains(where: { $0.name == FirebaseManager.shared.name }) {
                if context == .startedVenue {
                    cta.isHidden = true
                    callToAction.setTitle("Request Catering", for: .normal)
                }
            }
            if let reviewChild = reviewsChild.tableView.visibleCells.first {
                reviewsHeightConstraint.constant = reviewChild.bounds.height
            }
        }
    }
    var context: VenueDetailsContext = .listing
    var role: User.Role? {
        didSet {
            if role == .admin {
                callToAction.isHidden = true
            }
        }
    }
    
    private var featureListKVO: NSKeyValueObservation?
    private var capacityListKVO: NSKeyValueObservation?
    private var facilitiesListKVO: NSKeyValueObservation?
    private var pricingListKVO: NSKeyValueObservation?
    
    private var localSearch: MKLocalSearch!
    private var localSearchRequest: MKLocalSearch.Request!
    private var localSearchResponse: MKLocalSearch.Response!
    private var annotationView: MKAnnotationView!
    private var locationAnnotation: LocationAnnotation!
    private var mapItem: MKMapItem?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        collectionView.register(UINib(nibName: PhotoCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        setElements()
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(LocationAnnotation.self))
        mapView.delegate = self
        setAddressLocationOnMap()
        manageRole()
        manageVenue()
    }
    
    // MARK: - Elements
    
    private let featuresChild = ItemsViewController<String, BulletedListCell>()
    private let capacityChild = ItemsViewController<CapacityType, ValueCell>()
    private let facilitiesChild = ItemsViewController<Facility, DefaultCell>()
    private let pricingChild = ItemsViewController<PricingType, ValueCell>()
    private let reviewsChild = NibItemsViewController<Review, ReviewCell>()
    
    private func setElements() {
        descriptionView.text = venue.description
        
        featuresChild.items = venue.features
        featuresChild.configure = { feature, cell in
            cell.textLabel?.text = feature
        }
        featuresChild.willDisplay = { cell, indexPath in
            cell.frame.origin.y = 30
            UIView.animate(withDuration: 0.5, delay: 0.1 * Double(indexPath.row), animations: {
                cell.frame.origin.y = 0
            })
        }
        embed(featuresChild, into: featuresView)
        featureListKVO = featuresChild.tableView.observe(\.contentSize, options: .new) {
            self.featuresViewHeightConstraint.constant = $1.newValue!.height
        }
        
        let capacity = [
            CapacityType.standing(venue.capacity.standing),
            CapacityType.theatre(venue.capacity.theatre),
            CapacityType.dining(venue.capacity.dining),
            CapacityType.boardroom(venue.capacity.boardroom),
            CapacityType.uShaped(venue.capacity.uShaped)
        ]
        capacityChild.items = capacity
        capacityChild.configure = {
            $1.textLabel?.text = $0.name
            $1.detailTextLabel?.text = "up to \($0.value)"
        }
        embed(capacityChild, into: capacityView)
        capacityListKVO = capacityChild.tableView.observe(\.contentSize, options: .new) {
            self.capacityViewHeightConstraint.constant = $1.newValue!.height
        }
        
        var facilities = [Facility]()
        for item in venue.facilities {
            FacilityType.allCases.filter { $0.name == item }.forEach {
                facilities.append(Facility(image: $0.image, name: $0.name))
            }
        }
        facilitiesChild.items = facilities
        facilitiesChild.configure = {
            $1.textLabel?.text = $0.name
            $1.imageView?.image = $0.image
        }
        embed(facilitiesChild, into: facilitiesView)
        facilitiesListKVO = facilitiesChild.tableView.observe(\.contentSize, options: .new) {
            self.facilitiesViewHeightConstraint.constant = $1.newValue!.height
        }
        
        let pricing = [
            PricingType.hourly(venue.pricing.hourly),
            PricingType.halfDay(venue.pricing.halfDay),
            PricingType.fullDay(venue.pricing.fullDay),
            PricingType.multiDay(venue.pricing.multiDay)
        ]
        pricingChild.items = pricing
        pricingChild.configure = {
            $1.textLabel?.text = $0.name
            $1.detailTextLabel?.text = $0.userValue
        }
        embed(pricingChild, into: pricingView)
        pricingListKVO = pricingChild.tableView.observe(\.contentSize, options: .new) {
            self.pricingViewHeightConstraint.constant = $1.newValue!.height
        }
        
        [featuresChild, capacityChild, facilitiesChild, pricingChild].forEach {
            $0.tableView.isScrollEnabled = false
            $0.tableView.rowHeight = 30
        }
        
        embed(reviewsChild, into: reviewsView)
        reviewsChild.configure = { review, cell in
            cell.populate(with: review)
        }
        
        switch context {
        case .listing:
            cta.isHidden = true
            callToAction.setTitle("Edit Listing", for: .normal)
        case .book:
            cta.isHidden = true
            callToAction.setTitle("Book Now", for: .normal)
        case .startedVenue:
            cta.isHidden = false
            if venue.rates.contains(where: { $0.name == FirebaseManager.shared.name }) {
                cta.isHidden = true
                callToAction.setTitle("Request Catering", for: .normal)
            } else {
                callToAction.setTitle("Rate", for: .normal)
            }
        case .upcomingBooking:
            cta.isHidden = true
            callToAction.isHidden = true
        case .pastBooking:
            cta.isHidden = true
            if venue.rates.contains(where: { $0.name == FirebaseManager.shared.name }) {
                callToAction.isHidden = true
            } else {
                callToAction.setTitle("Rate", for: .normal)
            }
        }
    }
    
    private func setAddressLocationOnMap() {
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = venue.address
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) in
            if let localSearchResponse = localSearchResponse {
                for mapItem in localSearchResponse.mapItems {
                    self.mapItem = mapItem
                    self.configureUserActivity()
                }
                let coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)
                self.locationAnnotation = LocationAnnotation(coordinate: coordinate)
                self.locationAnnotation.imageName = "pos"
                let coordinateRegion = MKCoordinateRegion(center: self.locationAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
                self.mapView.centerCoordinate = self.locationAnnotation.coordinate
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.mapView.addAnnotation(self.locationAnnotation)
            }
        }
    }
    
    private func configureUserActivity() {
        let activity = NSUserActivity(activityType: "com.upgraders.vennu.view-location")
        activity.isEligibleForSearch = true
        activity.title = mapItem?.name
        activity.keywords = ["venue"]
        activity.delegate = self
        userActivity = activity
    }
    
    // MARK: - Actions
    
    @IBAction func openMapItemInMaps(_ sender: Any) {
        mapItem?.openInMaps(launchOptions: nil)
    }
    
    @objc func back() {
        #if PRO
        if role == .admin {
            flowController.backToSearchList()
        } else {
            flowController.goToList()
        }
        #elseif USER
        if context == .book {
            flowController.goToExplore()
        } else {
            dismiss(animated: true)
        }
        #endif
    }
    
    @IBAction func callToAction(_ sender: Any) {
        #if PRO
        flowController.goToEditVenue(venue)
        #elseif USER
        if context == .startedVenue {
            requestCatering()
        } else {
            let vc = RateViewController.instantiate(storyboard: "RoomDetail")
            vc.venue = venue
            let presentingViewController = self.presentingViewController
            dismiss(animated: true) {
                presentingViewController?.present(vc, animated: true)
            }
        }
        #endif
    }
}

// MARK: - Collection View Data Source

extension VenueDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venue.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
        let photoURL = venue.photos[indexPath.row]
        cell.populate(with: photoURL)
        return cell
    }
}

// MARK: - Collection View Delegate

extension VenueDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoURL = venue.photos[indexPath.row]
        flowController.goToPhoto(photoURL)
    }
}

// MARK: - Map View Delegate

extension VenueDetailsViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(LocationAnnotation.self), for: annotation)
        annotationView.image = UIImage(named: "pos")
        return annotationView
    }
}

// MARK: - User Activity Delegate

extension VenueDetailsViewController: NSUserActivityDelegate {
    override func updateUserActivityState(_ activity: NSUserActivity) {
        activity.mapItem = mapItem
    }
}

// MARK: - Web Services

extension VenueDetailsViewController {
    private func manageVenue() {
        FirebaseManager.shared.venue(id: venue.id) { venue in
            self.venue.photos = venue.photos
            self.venue.address = venue.address
            self.venue.reviews = venue.reviews
            self.reviewsChild.tableView.reloadData()
            self.reviewCountLabel.text = String(venue.reviews.count)
            self.setAddressLocationOnMap()
            self.collectionView.reloadData()
        }
    }
    
    private func manageRole() {
        if let email = FirebaseManager.shared.currentUser?.email {
            FirebaseManager.shared.role(for: email) { self.role = $0 }
        }
    }
    
    #if USER
    private func requestCatering() {
        FirebaseManager.shared.requestAssistance(at: venue) { error in
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                self.flowController.requestedAssistance()
            }
        }
    }
    #endif
}

// MARK: - Navigation

extension VenueDetailsViewController {
    private func setNavigation() {
        let image = UIImage(systemName: "chevron.left")?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
    }
}
