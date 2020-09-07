//
//  BookingsViewController.swift
//  users
//
//  Created by Ina Statkic on 02/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class BookingsViewController: SegmentedViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: - Properties

    private var upcomingVenues = [Venue]() {
        didSet {
            upcomingChild.items = upcomingVenues
            upcomingChild.snapshot()
            emptyLabel.isHidden = !upcomingVenues.isEmpty
        }
    }
    private var pastVenues = [Venue]() {
        didSet {
            pastChild.items = pastVenues
            pastChild.snapshot()
        }
    }
    private var startedVenues = [Venue]()
    
    // MARK: - Elements
    
    private lazy var upcomingChild = CollectionsViewController(items: upcomingVenues) { (venue, cell: BookingCell) in
        cell.populate(with: venue)
    }
    private lazy var pastChild = CollectionsViewController(items: pastVenues) { (venue, cell: BookingCell) in
        cell.populate(with: venue)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .desertStorm
        setNavigation()
        manageBookings()
        setElements()
    }
    
    // MARK: - Set
    
    override func segmentChange(_ sender: UISegmentedControl) {
        super.segmentChange(sender)
        let title = segmentedControl.titleForSegment(at: sender.selectedSegmentIndex)
        if title == Segment.upcoming.rawValue {
            emptyLabel.isHidden = !upcomingVenues.isEmpty
        } else if title == Segment.past.rawValue {
            emptyLabel.isHidden = !pastVenues.isEmpty
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.x == 0 {
            emptyLabel.isHidden = !upcomingVenues.isEmpty
        } else if scrollView.contentOffset.x == view.frame.size.width {
            emptyLabel.isHidden = !pastVenues.isEmpty
        }
    }
    
    private func setElements() {
        embed([upcomingChild, pastChild], into: scrollView)
        upcomingChild.didSelect = {
            self.flowController.goToVenueDetails($0, context: .upcomingBooking)
        }
        pastChild.didSelect = {
            self.flowController.goToVenueDetails($0, context: self.startedVenues.contains($0) ? .startedVenue : .pastBooking)
        }
    }

}

// MARK: - Web Services

extension BookingsViewController {
    private func manageBookings() {
        FirebaseManager.shared.bookedUserVenues { upcomingVenues, pastVenues, startedVenues  in
            self.upcomingVenues = upcomingVenues
            self.pastVenues = pastVenues
            self.startedVenues = startedVenues
        }
    }
}

// MARK: - Navigation

extension BookingsViewController {
    private func setNavigation() {
        navigationItem.title = "BOOKINGS"
    }
}
