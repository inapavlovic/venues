//
//  SuccessAlertViewController.swift
//  vennu
//
//  Created by Ina Statkic on 20/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class SuccessAlertViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = ListFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var completeButton: LongRoundButton!
    @IBOutlet weak var duplicateButton: UIButton!
    
    // MARK: - Properties
    
    var venueRequest = VenueRequest()
    var venue: Venue?
    var success: Success = .createdVenue
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        set()
    }
    
    private func set() {
        successLabel.text = success.text
        if success != .createdVenue {
            completeButton.isHidden = true
            duplicateButton.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            switch self.success {
            case .createdVenue: ()
            case .updatedVenue:
                self.flowController.goToVenueDetails(self.venue, context: .listing)
            case .updatedProfile, .updatedCateringInfo, .updatedBookingFee, .requestedAssistance:
                self.dismiss(animated: true)
            case .resetPasswordLinkSent:
                let presentingController = self.presentingViewController
                let vc = SignInViewController.instantiate(storyboard: "Auth")
                self.dismiss(animated: true) {
                    presentingController?.show(vc, sender: self)
                }
            case .paymentComplete:
                let presentingControler = self.presentingViewController
                self.dismiss(animated: true) {
                    presentingControler?.dismiss(animated: true)
                }
            }
        }
    }
    
    // MARK: - Actions

    #if PRO
    @IBAction func duplicateVenue(_ sender: Any) {
        activityIndicatorView.startAnimating()
        addVenue()
    }
    
    @IBAction func complete(_ sender: Any) {
        flowController.goToList()
    }
    #endif
    
}

// MARK: - Web Services

#if PRO
extension SuccessAlertViewController {
    private func addVenue() {
        FirebaseManager.shared.addVenue(request: venueRequest) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                debugPrint("Venue successfully published")
                self.flowController.goToList()
            }
        }
    }
}
#endif
