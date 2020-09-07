//
//  PhoneVerificationViewController.swift
//  users
//
//  Created by Ina Statkic on 22/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class PhoneVerificationViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = AuthFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var formView: FormView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions

    @IBAction func submit(_ sender: Any) {
        do {
            try formView.auth.validatePhoneNumber()
            activityIndicatorView.startAnimating()
            managePhoneVerification()
        } catch let error as Authentication.ValidateError {
            showError(title: "", message: error.localizedDescription)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}

// MARK: - Web Services

extension PhoneVerificationViewController {
    private func managePhoneVerification() {
        FirebaseManager.shared.verifyPhoneNumber(formView.auth) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                FirebaseManager.shared.completeUser(FirebaseManager.shared.uid, self.formView.auth, .user) {
                    self.flowController.goToCodePhoneVerification()
                }
            }
        }
    }
}
