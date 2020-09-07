//
//  SignUpViewController.swift
//  vennu
//
//  Created by Ina Statkic on 07/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class SignUpUserViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = AuthFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var formView: FormView!
    @IBOutlet weak var signInWithAppleButton: AppleIDButton!
    
    // MARK: - Properties
    
    lazy var signWithApple = SignWithApple(self)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signWithApple.set(signInWithAppleButton)
    }
    
    // MARK: - Actions
    
    @IBAction func signUp(_ sender: Any) {
        do {
            try formView.auth.validateUser()
            activityIndicatorView.startAnimating()
            manageSignUp()
        } catch let error as Authentication.ValidateError {
            showError(title: "", message: error.localizedDescription)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        flowController.goToSignIn()
    }
    
    @IBAction func signInWithFB(_ sender: Any) {
        activityIndicatorView.startAnimating()
        fbSignIn()
    }

}

// MARK: - Web Services

extension SignUpUserViewController {
    private func manageSignUp() {
        FirebaseManager.shared.signUp(formView.auth, .user) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "Sign up failed", message: error.localizedDescription)
            } else {
                self.flowController.goToPhoneVerification()
            }
        }
    }
    
    private func fbSignIn() {
        FirebaseManager.shared.fbSignIn(currentController: self, .user, completion: { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                FirebaseManager.shared.userBy(FirebaseManager.shared.uid) { user in
                    if user?.phoneNumber != nil {
                        self.flowController.goToList()
                    } else {
                        self.flowController.goToPhoneVerification()
                    }
                }
            }
        }) { cancelled in
            // Due FB SFAuthenticationViewController
            if cancelled {
                self.flowController.pushToSignUpUser()
            }
        }
    }
}
