//
//  SignInViewController.swift
//  vennu
//
//  Created by Ina Statkic on 07/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class SignInViewController: BaseViewController {
    
    // MARK: Flow
    
    lazy var flowController = AuthFlowController(self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var formView: FormView!
    @IBOutlet weak var signInWithAppleButton: AppleIDButton!
    
    // MARK: - Properties
    
    lazy var signWithApple = SignWithApple(self)
    var targetRole: User.Role! = .pro
    var venue: Venue?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        signWithApple.set(signInWithAppleButton)
        #if USER
        targetRole = .user
        #endif
    }
    
    // MARK: - Actions
    
    @IBAction func signIn(_ sender: Any) {
        do {
            try formView.auth.validateEmailAndPassword()
            activityIndicatorView.startAnimating()
            manageSignIn()
        } catch let error as Authentication.ValidateError {
            showError(title: "", message: error.localizedDescription)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @IBAction func signInWithFB(_ sender: Any) {
        activityIndicatorView.startAnimating()
        fbSignIn()
    }
    
    @IBAction func goToForgotPassword(_ sender: Any) {
        flowController.goToForgotPassword()
    }
    
    @IBAction func goToSignUp(_ sender: Any) {
        #if PRO
        flowController.goToSignUp()
        #elseif USER
        flowController.goToSignUpUser()
        #endif
    }
    
}

// MARK: - Web Services

extension SignInViewController {
    private func manageSignIn() {
        FirebaseManager.shared.role(for: formView.auth.email!) { userRole in
            self.activityIndicatorView.stopAnimating()
            if userRole == .admin && self.targetRole == .pro {
                self.activityIndicatorView.startAnimating()
                self.signIn(role: .admin)
                UserDefaults.admin = true
            } else if self.targetRole != userRole {
                self.showError(title: "Sign in failed", message: "Please enter email within application")
            } else {
                guard let userRole = userRole else { return }
                self.activityIndicatorView.startAnimating()
                self.signIn(role: userRole)
            }
        }
    }
    
    private func signIn(role: User.Role) {
        FirebaseManager.shared.signIn(formView.auth) { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "Sign in failed", message: error.localizedDescription)
            } else {
                #if PRO
                self.flowController.goToList(role)
                #elseif USER
                if let venue = self.venue {
                    self.flowController.goToBook(venue: venue)
                } else {
                    self.flowController.goToList()
                }
                #endif
            }
        }
    }
    
    private func fbSignIn() {
        FirebaseManager.shared.fbSignIn(currentController: self, targetRole, completion: { error in
            self.activityIndicatorView.stopAnimating()
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            } else {
                FirebaseManager.shared.userBy(FirebaseManager.shared.uid) { user in
                    guard let user = user else { return }
                    if user.role == .admin { UserDefaults.admin = true }
                    if user.phoneNumber != nil {
                        #if PRO
                        self.flowController.goToList(user.role)
                        #elseif USER
                        self.flowController.goToList()
                        #endif
                    } else {
                        #if PRO
                        self.flowController.goToCompleteSign()
                        #elseif USER
                        self.flowController.goToPhoneVerification()
                        #endif
                    }
                }
            }
        }) { cancelled in
            // Due FB SFAuthenticationViewController
            if cancelled {
                self.flowController.pushToSignIn()
            }
        }
    }
}
