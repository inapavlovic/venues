//
//  ViewController.swift
//  users
//
//  Created by Ina Statkic on 22/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class ExploreViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchView: SearchView!
    @IBOutlet weak var recentSearchesView: UIView!
    @IBOutlet weak var popularVenuesView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lastSearchesLabel: UILabel!
    
    // MARK: Properties
    
    private let locationManager = CLLocationManager()
    private var locationAnnotation: LocationAnnotation!
    private var annotationView: MKAnnotationView!
    
    private var venues = [Venue]() {
        didSet {
            popularVenuesChild.items = venues.filter { $0.popular }
            recentSearchesChild.items = venues.filter {
                recentSearches.contains(where: $0.location.contains)
            }
            emptyLabel.isHidden = !venues.isEmpty
            recentSearchesView.isHidden = venues.isEmpty
            lastSearchesLabel.isHidden = venues.isEmpty
        }
    }
    
    private var recentlySearchedLocations: Set<String> = [] {
        didSet {
            recentSearches = recentlySearchedLocations.sorted()
        }
    }
    private var recentSearches: [String] = []
    private var recentSearchesFileName: String = "recentSearches.txt"
    private var recentSearchesSeparator: String = "|"
    var numberOfPeople: Int = 15
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        unsetNavigation()
        setTitle()
        manageVenues()
        setElements()
        setActions()
        mapView.delegate = self
        mapView.register(BringNearestVenuesAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(LocationAnnotation.self))
        setCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        searchView.text = nil
        readRecentSearches()
        manageVenues()
        searchView.numberOfPeople = numberOfPeople
    }
    
    // MARK: - Set
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setTitle() {
        titleLabel.attributedText = NSAttributedString(string: "EXPLORE", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .kern : 0.92, .foregroundColor : UIColor.white])
    }
    
    private func setCurrentLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        }
        if let coordinate = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coordinate, animated: true)
        }
    }
    
    // MARK: - Methods
    
    private var recentSearchesFileURL: URL? {
        let fileManager = FileManager.default
        guard let url = fileManager.applicationSupportURL else { return nil }
        let fileURL = url.appendingPathComponent(recentSearchesFileName)
        return fileURL
    }
    
    private func readRecentSearches() {
        let fileManager = FileManager.default
        guard let fileURL = recentSearchesFileURL else { return }
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            guard
                let data = fileManager.contents(atPath: fileURL.path),
                let encodingData = String(data: data, encoding: .utf8)
            else {
                return
            }
            let recentSearchesData = encodingData.components(separatedBy: self.recentSearchesSeparator)
            self.recentlySearchedLocations = Set(recentSearchesData)
        }
    }
    
    private func saveRecentSearches() {
        guard let fileURL = recentSearchesFileURL else { return }
        DispatchQueue.global(qos: .utility).async { [unowned self] in
            let recentSearches = self.recentlySearchedLocations.joined(separator: self.recentSearchesSeparator)
            do {
                try recentSearches.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch let fileError {
                debugPrint(fileError.localizedDescription)
            }
        }
    }
    
    private func currentLocationName(completion: @escaping (CLPlacemark?) -> ()) {
        if let location = locationManager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?.first
                    completion(firstLocation)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    // MARK: - Elements
    
    var popularVenuesChild = CollectionItemsViewController<Venue, PopularVenueCell>()
    var recentSearchesChild = CollectionItemsViewController<Venue, RecentSearchCell>()
    
    private func setElements() {
        embed(popularVenuesChild, into: popularVenuesView)
        popularVenuesChild.configure = { venue, cell in
            cell.populate(with: venue)
        }
        popularVenuesChild.itemSize = CGSize(width: 160, height: 210)
        popularVenuesChild.didSelect = {
            self.flowController.goToRoomDetail(venue: $0)
        }
        
        embed(recentSearchesChild, into: recentSearchesView)
        recentSearchesChild.configure = { venue, cell in
            cell.populate(with: venue)
        }
        recentSearchesChild.itemSize = CGSize(width: 135, height: 160)
        recentSearchesChild.didSelect = {
            self.flowController.goToRoomDetail(venue: $0)
        }
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            recentSearchesView.centerXAnchor.constraint(equalTo: emptyLabel.centerXAnchor),
            recentSearchesView.centerYAnchor.constraint(equalTo: emptyLabel.centerYAnchor)
        ])
    }
    
    var emptyLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 50))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .tuna
        label.text = "No venues yet."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Actions
    
    private func setActions() {
        searchView.didSearch = { [weak self] searchText in
            guard let self = self else { return }
            self.recentlySearchedLocations.insert(searchText)
            self.saveRecentSearches()
            self.flowController.goToSearchList(searchText: searchText, numberOfPeople: self.numberOfPeople)
        }
        searchView.pickNumberOfPeople = { [weak self] in
            self?.numberOfPeople = $0
        }
    }

}

// MARK: - Location Manager Delegate, Map View Delegate

extension ExploreViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        locationAnnotation = LocationAnnotation(coordinate: coordinate)
        locationAnnotation.title = "BRING NEAREST VENUES"
        locationAnnotation.imageName = "point"
        let coordinateRegion = MKCoordinateRegion(center: locationAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(locationAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(LocationAnnotation.self), for: annotation)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.selectedAnnotations.removeAll()
        currentLocationName { placemark in
            self.flowController.goToSearchList(searchText: placemark?.locality ?? "", numberOfPeople: self.numberOfPeople)
        }
    }
}

// MARK: - Web Services

extension ExploreViewController {
    private func manageVenues() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.venues { venues in
            self.activityIndicatorView.stopAnimating()
            self.venues = venues
            self.popularVenuesChild.collectionView.reloadData()
            self.recentSearchesChild.collectionView.reloadData()
        }
    }
}

// MARK: - Navigation

extension ExploreViewController {
    private func unsetNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

