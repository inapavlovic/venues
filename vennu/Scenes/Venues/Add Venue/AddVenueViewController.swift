//
//  AddVenueViewController.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Photos
import Kingfisher
import GooglePlaces

struct AddVenue {
    var address: String = ""
    var description: String = ""
    var photos: [UIImage] = []
    var features: [String] = []
    var capacity: [CapacityType] = []
    var facilities: [Facility] = []
    var pricing: [PricingType] = []
    var capacityValues: [Int] = []
    var priceValues: [Double] = []
}

final class AddVenueViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)

    // MARK: - Outlets
    
    @IBOutlet weak var basicDetailsView: BasicDetailsView!
    @IBOutlet weak var addressSuggestionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addressSuggestionsView: UIView!
    @IBOutlet weak var descriptionView: DescriptionView!
    @IBOutlet weak var featuresView: UIView!
    @IBOutlet weak var capacityView: UIView!
    @IBOutlet weak var facilitiesView: UIView!
    @IBOutlet weak var pricingView: UIView!
    @IBOutlet weak var connectCalendarButton: LongOutlineRoundButton!
    @IBOutlet weak var publishButton: LongRoundButton!
    @IBOutlet weak var featuresViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var capacityViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var facilitiesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pricingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var venue: Venue?
    lazy var venueRequest = VenueRequest()
    
    var state = AddVenue() {
        didSet {
            venueRequest.address = state.address
            basicDetailsView.address = state.address
            venue?.description = state.description
            venueRequest.description = state.description
            descriptionView.text = state.description
            venueRequest.photos = state.photos
            featuresChild.items = state.features
            venueRequest.features = state.features
            venue?.features = state.features
            capacityChild.items = state.capacity
            facilitiesChild.items = state.facilities
            pricingChild.items = state.pricing
            state.capacityValues = state.capacity.map { $0.value }
            venueRequest.capacity = Capacity(
                standing: state.capacityValues[contains: 0] ?? 0,
                theatre: state.capacityValues[contains: 1] ?? 0,
                dining: state.capacityValues[contains: 2] ?? 0,
                boardroom: state.capacityValues[contains: 3] ?? 0,
                uShaped: state.capacityValues[contains: 4] ?? 0)
            venue?.capacity = venueRequest.capacity!
            venueRequest.facilities = state.facilities.map { $0.name }
            venue?.facilities = state.facilities.map { $0.name }
            state.priceValues = state.pricing.map { $0.value }
            venueRequest.pricing = Pricing(
                hourly: state.priceValues[contains: 0] ?? 0,
                halfDay: state.priceValues[contains: 1] ?? 0,
                fullDay: state.priceValues[contains: 2] ?? 0,
                multiDay: state.priceValues[contains: 3] ?? 0)
            venue?.pricing = venueRequest.pricing!
        }
    }
    
    let autocompleteViewController = GMSAutocompleteViewController()
    var imagePicker: ImagePicker!
    
    var addressSuggestionsKVO: NSKeyValueObservation?
    var featureListKVO: NSKeyValueObservation?
    var capacityListKVO: NSKeyValueObservation?
    var facilitiesListKVO: NSKeyValueObservation?
    var pricingListKVO: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        collectionView.register(UINib(nibName: PhotoCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        collectionView.register(UINib(nibName: AddPhotoCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: AddPhotoCell.reuseIdentifier)
        collectionView.dataSource = self
        autocompleteViewController.delegate = self
        setAutocompleteAddress()
        imagePicker = ImagePicker(vc: self, delegate: self)
        setElements()
        setVenue()
        setActions()
        processPhotos()
    }
    
    // MARK: - Methods
    
    private func setAutocompleteAddress() {
        autocompleteViewController.view.tintColor = .coralRed
//        autocompleteViewController.autocompleteFilter?.countries = ["gb"]
        autocompleteViewController.autocompleteFilter?.type = .address
    }
    
    private func setVenue() {
        if let venue = venue {
            venueRequest.title = venue.title
            basicDetailsView.title = venueRequest.title
            state.address = venue.address
            state.description = venue.description
            state.features = venue.features
            let capacity = [
                 CapacityType.standing(venue.capacity.standing),
                 CapacityType.theatre(venue.capacity.theatre),
                 CapacityType.dining(venue.capacity.dining),
                 CapacityType.boardroom(venue.capacity.boardroom),
                 CapacityType.uShaped(venue.capacity.uShaped)
             ]
            state.capacity = capacity
            var venueFacilities = [Facility]()
            for item in venue.facilities {
                FacilityType.allCases.filter { $0.name == item }.forEach {
                    venueFacilities.append(Facility(image: $0.image, name: $0.name))
                }
            }
            state.facilities = venueFacilities
            let pricing = [
                PricingType.hourly(venue.pricing.hourly),
                PricingType.halfDay(venue.pricing.halfDay),
                PricingType.fullDay(venue.pricing.fullDay),
                PricingType.multiDay(venue.pricing.multiDay)
            ]
            state.pricing = pricing
        }
    }
    
    private func processPhotos() {
        if let venue = venue {
            venue.photos.forEach {
                KingfisherManager.shared.retrieveImage(with: $0.absoluteURL) { (result) in
                    switch result {
                    case .success(let imageResult):
                        self.state.photos.append(imageResult.image)
                        self.collectionView.reloadData()
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Elements

    let featuresChild = ItemsViewController<String, BulletedListCell>()
    let capacityChild = ItemsViewController<CapacityType, ValueCell>()
    let facilitiesChild = ItemsViewController<Facility, DefaultCell>()
    let pricingChild = ItemsViewController<PricingType, ValueCell>()

    private func setElements() {
        featuresChild.configure = { $1.textLabel?.text = $0 }
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

        capacityChild.configure = { capacity, cell  in
            cell.textLabel?.text = capacity.name
            cell.detailTextLabel?.text = "up to \(capacity.value)"
        }
        embed(capacityChild, into: capacityView)
        capacityListKVO = capacityChild.tableView.observe(\.contentSize, options: .new) {
            self.capacityViewHeightConstraint.constant = $1.newValue!.height
        }

        facilitiesChild.configure = {
            $1.textLabel?.text = $0.name
            $1.imageView?.image = $0.image
        }
        embed(facilitiesChild, into: facilitiesView)
        facilitiesListKVO = facilitiesChild.tableView.observe(\.contentSize, options: .new) {
            self.facilitiesViewHeightConstraint.constant = $1.newValue!.height
        }

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
    }
    
    // MARK: - Actions
    
    func setActions() {
        if venue != nil {
            connectCalendarButton.isHidden = true
            publishButton.setTitle("Update", for: .normal)
        }
        
        descriptionView.descript = { [weak self] in
            self?.state.description = $0
        }
        
        basicDetailsView.changeTitle = { [weak self] in
            self?.venueRequest.title = $0
        }
        
        basicDetailsView.startTyping = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.present(self.autocompleteViewController, animated: true)
        }
    }
    
    @IBAction func addFeatures(_ sender: Any) {
        flowController.goToAddFeatures(venue?.features)
    }
    
    @IBAction func addCapacity(_ sender: Any) {
        flowController.goToAddCapacity(venue?.capacity)
    }
    
    @IBAction func addFacilities(_ sender: Any) {
        flowController.goToAddFacilities(venue?.facilities)
    }
    
    @IBAction func addPricing(_ sender: Any) {
        flowController.goToAddPricing(venue?.pricing)
    }
    
    @IBAction func publish(_ sender: Any) {
        view.endEditing(true)
        do {
            try venueRequest.validate()
            activityIndicatorView.startAnimating()
            if venue != nil {
                updateVenue()
            } else if venue == nil {
                addVenue()
            }
        } catch let error as VenueRequest.ValidateError {
            showError(title: "", message: error.localizedDescription)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
        if venue != nil {
            dismiss(animated: true)
        }
    }
}

// MARK: - Image Picker Delegate

extension AddVenueViewController: ImagePickerDelegate {
    func picked(_ image: UIImage) {
        state.photos.append(image)
        collectionView.reloadData()
    }
}

// MARK: - Collection View Data Source

extension AddVenueViewController: UICollectionViewDataSource {
    
    enum Section: Int {
        case addPhoto
        case photos
        
        init(at indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)!
        }
        
        init(_ section: Int) {
            self.init(rawValue: section)!
        }
        static let count = 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(section) {
        case .addPhoto: return 1
        case .photos: return state.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(at: indexPath)
        switch section {
        case .addPhoto:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.reuseIdentifier, for: indexPath) as! AddPhotoCell
            cell.delegate = self
            return cell
        case .photos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier, for: indexPath) as! PhotoCell
            let photo = state.photos[indexPath.row]
            cell.populate(with: photo, delegate: self, indexPath: indexPath)
            return cell
        }
    }
}

// MARK: - Autocomplete Delegate

extension AddVenueViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        navigationController?.dismiss(animated: true)
        state.address = place.formattedAddress ?? ""
        for addressComponent in place.addressComponents ?? [] {
            for type in addressComponent.types {
                if type == "postal_town" || type == "locality" {
                    venueRequest.location = addressComponent.name
                }
            }
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - Add Photo Delegate

extension AddVenueViewController: AddPhotoDelegate {
    func addPhoto() {
        let alert = UIAlertController()
        alert.view.tintColor = .coralRed
        let takePhoto = UIAlertAction(title: "Take photo", style: .default) { action in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            self.imagePicker.imagePickerController.sourceType = .camera
            self.present(self.imagePicker.imagePickerController, animated: true)
        }
        let pickPhoto = UIAlertAction(title: "Pick photo", style: .default) { action in
            self.imagePicker.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePicker.imagePickerController, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(takePhoto)
        alert.addAction(pickPhoto)
        alert.addAction(cancel)
        if let popoverPresentationController = alert.popoverPresentationController {
            let selectedCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))!
            popoverPresentationController.sourceRect = selectedCell.frame
            popoverPresentationController.sourceView = collectionView
            popoverPresentationController.permittedArrowDirections = .up
        }
        present(alert, animated: true)
    }
}

// MARK: - Remove Photo Delegate

extension AddVenueViewController: PhotoCellDelegate {
    func didRemove(_ indexPath: IndexPath) {
        alert(title: "Remove photo", message: "Are you sure you want to remove photo?", actions: "Remove") {
            if $0 == 0 {
                self.state.photos.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Features Delegate

extension AddVenueViewController: FeaturesDelegate {
    func features(_ vc: FeaturesViewController, _ features: [String]) {
        state.features = features
        featuresChild.tableView.reloadData()
    }
}

// MARK: - Capacity Delegate

extension AddVenueViewController: CapacityDelegate {
    func capacity(_ vc: CapacityViewController, _ capacity: [CapacityType]) {
        state.capacity = capacity
        capacityChild.tableView.reloadData()
    }
}

// MARK: - Facilities Delegate

extension AddVenueViewController: FacilitiesDelegate {
    func facilities(_ vc: FacilitiesViewController, _ facilities: [Facility]) {
        state.facilities = facilities
        facilitiesChild.tableView.reloadData()
    }
}

// MARK: - Pricing Delegate

extension AddVenueViewController: PricingDelegate {
    func pricing(_ vc: PricingViewController, _ pricing: [PricingType]) {
        state.pricing = pricing
        pricingChild.tableView.reloadData()
    }
}

// MARK: - Web Services

extension AddVenueViewController {
    private func addVenue() {
        FirebaseManager.shared.addVenue(request: venueRequest) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                debugPrint("Venue successfully published")
                self.flowController.showSuccess(self.venueRequest, success: .createdVenue, venue: nil)
            }
        }
    }
    
    private func updateVenue() {
        guard let id = venue?.id else { return }
        FirebaseManager.shared.updateVenue(id: id, request: venueRequest) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                debugPrint("Venue successfully updated")
                self.flowController.showSuccess(self.venueRequest, success: .updatedVenue, venue: self.venue!)
            }
        }
    }
}

// MARK: - Navigation

extension AddVenueViewController {
    private func setNavigation() {
        let image = UIImage(systemName: venue != nil ? "chevron.down" : "chevron.left")?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))?.withTintColor(.tuna)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
    }
}

