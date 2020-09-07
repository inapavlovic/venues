//
//  CodePhoneVerificationViewController.swift
//  users
//
//  Created by Ina Statkic on 22/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class CodePhoneVerificationViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = AuthFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var formView: FormView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    // MARK: - Properties
    
    var phoneNumber: String = "" {
        didSet {
            phoneLabel.text = "Please, enter the code sent to \(phoneNumber)"
            formView.auth.phoneNumber = phoneNumber
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        managePhone()
    }
    
    // MARK: - Actions

    @IBAction func verify(_ sender: Any) {
        do {
            try formView.auth.validateVerificationCode()
            activityIndicatorView.startAnimating()
            managePhoneVerification()
        } catch let error as Authentication.ValidateError {
            showError(title: "", message: error.localizedDescription)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @IBAction func resendCode(_ sender: Any) {
        manageResendVerificationCode()
    }
}

// MARK: - Web Services

extension CodePhoneVerificationViewController {
    private func managePhone() {
        activityIndicatorView.startAnimating()
        FirebaseManager.shared.userBy(FirebaseManager.shared.uid) { user in
            self.activityIndicatorView.stopAnimating()
            if let phoneNumber = user?.phoneNumber {
                self.phoneNumber = phoneNumber
            }
        }
    }
    
    private func managePhoneVerification() {
        FirebaseManager.shared.linkPhoneWithAccount(formView.auth) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                self.manageCustomer()
            }
        }
    }
    
    private func manageCustomer() {
        StripeManager.shared.createCustomer() { customer in
            guard let customerId = customer?.id else { return }
            FirebaseManager.shared.customerUser(FirebaseManager.shared.uid, customerId: customerId) {
                self.flowController.goToList()
            }
        }
    }
    
    private func manageResendVerificationCode() {
        FirebaseManager.shared.verifyPhoneNumber(formView.auth) { error in
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            }
        }
    }
}
