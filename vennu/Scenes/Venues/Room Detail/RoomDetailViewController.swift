//
//  RoomDetailViewController.swift
//  vennu
//
//  Created by Ina Statkic on 13/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Kingfisher

final class RoomDetailViewController: UIViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet private weak var previewDetailView: PreviewDetailView!
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var bookButton: UIButton!
    @IBOutlet private weak var bookButtonHeight: NSLayoutConstraint!
    @IBOutlet var starsImageViews: [UIImageView]!
    
    // MARK: - Properties
    
    var venue: Venue!
    var rating = 0 {
        didSet {
            for (index, star) in starsImageViews.enumerated() {
                star.isHighlighted = index < rating
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPreview()
        setBook()
        setAvailability()
    }
    
    // MARK: - Set
    
    private func setPreview() {
        if let image = venue.photos.first {
            photoView.kf.setImage(with: image)
        }
        previewDetailView.title = venue.title
        previewDetailView.address = venue.address
        previewDetailView.price = Decimal(venue.pricing.hourly)
        if venue.rates.count > 0 {
            rating = venue.rates.map { $0.stars }.reduce(0, +) / venue.rates.count
        }
    }
    
    private func setBook() {
        #if PRO
        bookButton.isHidden = true
        bookButtonHeight.constant = 0
        #elseif USER
        bookButton.isHidden = false
        bookButton.addTarget(self, action: #selector(book(_:)), for: .touchUpInside)
        #endif
    }
    
    // MARK: - Actions
    
    #if USER
    @objc func book(_ sender: Any) {
        let presentingViewController = self.presentingViewController
        if FirebaseManager.shared.currentUser != nil {
            let vc = BookViewController.instantiate(storyboard: "Book")
            vc.venue = venue
            dismiss(animated: true) {
                presentingViewController?.present(vc, animated: true)
            }
        } else {
            let vc = SignInViewController.instantiate(storyboard: "Auth")
            vc.venue = venue
            let nc = AuthNavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            dismiss(animated: true) {
                presentingViewController?.present(nc, animated: true)
            }
        }
    }
    #endif
    
    private func setAvailability() {
        previewDetailView.availability = { [weak self] in
            guard let self = self else { return }
            let vc = CalendarViewController.instantiate(storyboard: "RoomDetail")
            let nc = PresentNavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .overFullScreen
            nc.modalTransitionStyle = .crossDissolve
            self.present(nc, animated: true)
        }
    }
    
    @IBAction func goToDetails(_ sender: Any) {
        #if PRO
        flowController.goToVenueDetails(venue, context: .listing)
        #elseif USER
        flowController.goToVenueDetails(venue, context: .book)
        #endif
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}
