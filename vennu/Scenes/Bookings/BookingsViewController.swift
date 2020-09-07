//
//  BookViewController.swift
//  vennu
//
//  Created by Ina Statkic on 09/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class BookingsViewController: SegmentedViewController {
    
    // MARK: Flow
    
    lazy var flowController = BookFlowController(self)
    
    // MARK: Properties
    
    private var upcomingBookings: [Booking] = [] {
        didSet {
            upcomingChild.items = upcomingBookings
            upcomingChild.snapshot()
            emptyLabel.isHidden = !upcomingBookings.isEmpty
        }
    }
    
    private var pastBookings: [Booking] = [] {
        didSet {
            pastChild.items = pastBookings
            pastChild.snapshot()
        }
    }
    
    // MARK: - Controls
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .desertStorm
        setActivityIndicator()
        manageBookings()
        set()
        setActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.layoutIfNeeded()
        pastChild.view.layoutIfNeeded()
        upcomingChild.view.layoutIfNeeded()
    }
    
    // MARK: - Elements
    
    private lazy var pastChild = CollectionsViewController(items: pastBookings) { (book, cell: BookingCell) in
        cell.populate(with: book)
    }
    
    private lazy var upcomingChild = CollectionsViewController(items: upcomingBookings) { (book, cell: BookingCell) in
        cell.populate(with: book)
    }
    
    // MARK: - Set
    
    private func setActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(frame: view.frame)
        view.addSubview(activityIndicatorView)
    }
    
    private func set() {
        embed([upcomingChild, pastChild], into: scrollView)
        [upcomingChild, pastChild].forEach {
            $0.view.clipsToBounds = false
        }
    }
    
    override func segmentChange(_ sender: UISegmentedControl) {
        super.segmentChange(sender)
        let title = segmentedControl.titleForSegment(at: sender.selectedSegmentIndex)
        if title == Segment.upcoming.rawValue {
            emptyLabel.isHidden = !upcomingBookings.isEmpty
        } else if title == Segment.past.rawValue {
            emptyLabel.isHidden = !pastBookings.isEmpty
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.x == 0 {
            emptyLabel.isHidden = !upcomingBookings.isEmpty
        } else if scrollView.contentOffset.x == view.frame.size.width {
            emptyLabel.isHidden = !pastBookings.isEmpty
        }
    }
    
    // MARK: - Actions
    
    private func setActions() {
        upcomingChild.didSelect = {
            self.flowController.goToBookingDetails(booking: $0)
        }
        pastChild.didSelect = {
            self.flowController.goToBookingDetails(booking: $0)
        }
    }
}

// MARK: - Web Services

extension BookingsViewController {
    private func manageBookings() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.bookings { bookings in
            self.activityIndicatorView.stopAnimating()
            self.upcomingBookings = bookings.filter { Date().daysHours(to: Date(timeIntervalSince1970: $0.startDate!)) > (0, 0) }
            self.pastBookings = bookings.filter { Date().daysHours(to: Date(timeIntervalSince1970: $0.startDate!)) <= (0, 0) }
        }
    }
}

// MARK: - Navigation

extension BookingsViewController {
    private func setNavigation() {
        navigationController?.navigationBar.isUserInteractionEnabled = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
