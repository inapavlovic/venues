//
//  MapViewController.swift
//  users
//
//  Created by Ina Statkic on 28/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var searchView: SearchView!
    @IBOutlet private weak var collectionView: UIView!
    
    // MARK: - Properties
    
    var searchText: String? = ""
    var numberOfPeople: Int!
    private var venues = [Venue]() {
        willSet {
            self.annotations.removeAll()
        }
        didSet {
            child.items = venues
            venues.forEach {
                self.coordinate(address: $0.address) { (locationCoordinate, error) in
                    if error == nil {
                        let locationAnnotation = LocationAnnotation(coordinate: locationCoordinate)
                        locationAnnotation.imageName = "pos"
                        self.annotations.append(locationAnnotation)
                    }
                }
            }
        }
    }
    
    private var annotationView: MKAnnotationView!
    private var locationAnnotation: LocationAnnotation!
    
    private var annotations = [LocationAnnotation]() {
        willSet {
            mapView.removeAnnotations(annotations)
        }
        didSet {
            mapView.addAnnotations(annotations)
            if let coordinate = annotations.first?.coordinate {
                centerMapOn(coordinate: coordinate)
            }
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(LocationAnnotation.self))
        mapView.delegate = self
        manageSearchVenues()
        setElements()
        searchView.text = searchText
        searchView.numberOfPeople = numberOfPeople
        setActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        unsetNavigation()
    }
    
    // MARK: - Elements
    
    private var child = CollectionItemsViewController<Venue, MapListCell>()
    
    private func setElements() {
        embed(child, into: collectionView)
        child.configure = { venue, cell in
            cell.populate(with: venue)
        }
        child.itemSize = CGSize(width: 280, height: 110)
    }
    
    // MARK: - Actions
    
    private func setActions() {
        
        searchView.searching = { [weak self] in
            self?.searchText = $0
        }
        searchView.didSearch = { [weak self] _ in
            self?.manageSearchVenues()
        }
        searchView.pickNumberOfPeople = { [weak self] in
            self?.numberOfPeople = $0
            self?.manageSearchVenues()
        }
        
        child.didSelect = {
            self.coordinate(address: $0.address) { (coordinate, error) in
                if error == nil {
                    self.centerMapOn(coordinate: coordinate)
                }
            }
        }
        
    }
    
    @objc private func back() {
        flowController.backToList(searchText: searchText!, numberOfPeople: numberOfPeople)
    }
    
    // MARK: - Methods
    
    private func coordinate(address: String, completion: @escaping (CLLocationCoordinate2D, NSError?) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first {
                    let location = placemark.location!
                    completion(location.coordinate, nil)
                    return
                }
            }
            completion(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    private func centerMapOn(coordinate: CLLocationCoordinate2D) {
        locationAnnotation = LocationAnnotation(coordinate: coordinate)
        let coordinateRegion = MKCoordinateRegion(center: locationAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - Map View Delegate

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(LocationAnnotation.self), for: annotation)
        annotationView.image = UIImage(named: "pos")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.selectedAnnotations.removeAll()
        child.collectionView.scrollToItem(at: IndexPath(item: annotations.firstIndex(of: view.annotation as! LocationAnnotation) ?? 0, section: 0), at: .left, animated: true)
    }
}

// MARK: - Web Services

extension MapViewController {
    private func manageSearchVenues() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.locationVenues(query: searchText!) { venues in
            self.activityIndicatorView.stopAnimating()
            self.venues = venues.filter { $0.capacity.numberOfPeople >= self.numberOfPeople }
            self.child.collectionView.reloadData()
        }
    }
}

// MARK: - Navigation

extension MapViewController {
    private func setNavigation() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        let image = UIImage(systemName: "chevron.left" )?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem?.tintColor = .tuna
    }
    private func unsetNavigation() {
        tabBarController?.tabBar.isHidden = false
    }
}
