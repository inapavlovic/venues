//
//  SignWithApple.swift
//  vennu
//
//  Created by Ina Statkic on 25/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import AuthenticationServices
import FirebaseAuth

final class SignWithApple: NSObject {
    
    // MARK: Properties
    
    var currentNonce: String?
    let randomNonce = RandomNonce()

    unowned var currentViewController: UIViewController
    lazy var flowController = AuthFlowController(currentViewController)
    
    // MARK: - Init
    
    init(_ vc: UIViewController) {
        self.currentViewController = vc
    }
    
    // MARK: - Action
    
    public func set(_ button: AppleIDButton) {
        button.addTarget(self, action: #selector(signInWithApple), for: .touchUpInside)
    }
    
    @objc private func signInWithApple() {
        let nonce = randomNonce.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = randomNonce.sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - Authorization Delegate

extension SignWithApple: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            let formatter  = PersonNameComponentsFormatter()
            let fullName = formatter.string(from: appleIDCredential.fullName!)
            
            var role: User.Role
            #if PRO
            role = .pro
            #elseif USER
            role = .user
            #endif
            // Commit changes to Firebase profile change request
            let profileChangeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            profileChangeRequest?.displayName = fullName
            profileChangeRequest?.commitChanges()
            FirebaseManager.shared.signInWith(credential, role, fullName) { error in
                if let error = error {
                    debugPrint(error.localizedDescription)
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
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
}

// MARK: - Authorization Presentation Context

extension SignWithApple: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return currentViewController.view.window!
    }
}
