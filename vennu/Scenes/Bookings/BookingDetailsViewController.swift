//
//  BookingDetailsViewController.swift
//  vennu
//
//  Created by Ina Statkic on 15/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
#if USER
import Stripe
#endif

final class BookingDetailsViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var venueTitleLabel: UILabel!
    @IBOutlet private weak var detailsView: BookingDetailsView!
    @IBOutlet private weak var priceView: BookingDetailsPriceView!
    @IBOutlet private weak var applyButton: UIButton!
    
    // MARK: - Properties

    var booking: Booking!
    private var customerHaveACard: Bool?
    private var card: String?
    #if PRO
    private var customer: String? {
        didSet {
            detailsView.customer = customer
        }
    }
    #elseif USER
    private var customerId: String?
    #endif
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCustomer()
        setBooking()
        note()
        fee()
        catering()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigation()
        setTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        unsetNavigation()
    }
    
    // MARK: - Set
    
    private func setTitle() {
        #if PRO
        title = "BOOKING DETAILS"
        #elseif USER
        title = "CHECK OUT"
        #endif
    }
    
    private func setCustomer() {
        #if PRO
        userCustomer()
        applyButton.isHidden = true
        #elseif USER
        userCustomerId()
        #endif
    }
    
    private func setBooking() {
        venueTitleLabel.text = booking.title
        detailsView.startDate = Date(timeIntervalSince1970: booking.startDate!)
        detailsView.duration = booking.duration?.shortDuration()
        priceView.rentPrice = Decimal(booking.rentPrice! / 100)
        priceView.totalPrice = Decimal(booking.rentPrice! / 100)
        detailsView.catering = booking.catering
        #if PRO
        detailsView.notes = booking.notes
        detailsView.startTime = Date(timeIntervalSince1970: booking.startDate!).startTime()
        #elseif USER
        priceView.totalPrice = Decimal(booking.rentPrice! + booking.cateringPrice + booking.fee)
        priceView.rentPrice = Decimal(booking.rentPrice!)
        detailsView.startTime = booking.startTime
        
        #endif
    }
    
    private func note() {
        detailsView.note = { [weak self] in
            self?.booking.notes = $0
        }
    }
    
    // MARK: - Actions
    
    @objc private func back() {
        #if PRO
        navigationController?.popViewController(animated: true)
        #elseif USER
        flowController.goToExplore()
        #endif
    }
    
    #if USER
    @IBAction func apply(_ sender: Any) {
        view.endEditing(true)
        self.activityIndicatorView.startAnimating()
        if customerHaveACard == true {
            self.booking.bookDate = Date().timeIntervalSince1970
            StripeManager.shared.book(self.booking, by: customerId!, withCard: card!, amount: self.booking.total!) { outcome in
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    if let outcome = outcome {
                        self.flowController.showSuccess(message: outcome.message)
                    }
                }
            }
        } else {
            let addCardViewController = AddCardViewController()
            addCardViewController.context = .booking
            addCardViewController.booking = booking
            let nc = PresentNavigationController(rootViewController: addCardViewController)
            present(nc, animated: true)
        }
    }
    #endif
}

// MARK: - Web Services

extension BookingDetailsViewController {
    #if USER
    private func userCustomerId() {
        self.activityIndicatorView.startAnimating()
        FirebaseManager.shared.userBy(FirebaseManager.shared.uid) { user in
            if let customerId = user?.customerId {
                self.customerId = customerId
                StripeManager.shared.customer(id: customerId) { customer in
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        if let customer = customer {
                            self.card = customer.card
                            self.customerHaveACard = true
                        }
                    }
                }
            }
        }
    }
    #elseif PRO
    private func userCustomer() {
        FirebaseManager.shared.userBy(booking.uid!) { user in
            self.customer = user?.name
        }
    }
    #endif
    private func fee() {
        FirebaseManager.shared.fee {
            self.priceView.fee = Decimal($0 ?? 0)
        }
    }
    private func catering() {
        FirebaseManager.shared.catering {
            self.booking.cateringPrice = $0.basic * Double(self.booking.catering?.basic ?? 0) + $0.premium * Double(self.booking.catering?.premium ?? 0)
            self.priceView.cateringPrice = Decimal(self.booking.cateringPrice)
        }
    }
}


// MARK: - Navigation

extension BookingDetailsViewController {
    private func setNavigation() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = .tuna
        navigationController?.navigationBar.backgroundColor = .desertStorm
        navigationController?.setStatusBar(backgroundColor: .desertStorm)
        let image = UIImage(systemName: "chevron.left" )?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(back))
    }
    private func unsetNavigation() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
    }
}
