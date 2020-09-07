//
//  ForgotPasswordViewController.swift
//  vennu
//
//  Created by Ina Statkic on 07/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class ForgotPasswordViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = AuthFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet private weak var formView: FormView!
    private var role: User.Role! = .pro
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if USER
        role = .user
        #endif
    }
    
    // MARK: - Actions
    
    @IBAction func resetPassword(_ sender: Any) {
        do {
            try formView.auth.validateEmail()
            activityIndicatorView.startAnimating()
            managePasswordReset()
        } catch let error as Authentication.ValidateError {
            showError(title: "", message: error.localizedDescription)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        flowController.goToSignIn()
    }
}

// MARK: - Web Services

extension ForgotPasswordViewController {
    private func managePasswordReset() {
        FirebaseManager.shared.role(for: formView.auth.email!) { userRole in
            self.activityIndicatorView.stopAnimating()
            if self.role != userRole {
                self.showError(title: "", message: "Please enter email within application")
            } else {
                self.activityIndicatorView.startAnimating()
                self.sendPasswordReset()
            }
        }
    }
    
    private func sendPasswordReset() {
        FirebaseManager.shared.sendPasswordResetWithEmail(formView.auth.email!) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                self.flowController.showSuccess()
            }
        }
    }
}
