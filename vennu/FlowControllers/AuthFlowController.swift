//
//  AuthFlowController.swift
//  vennu
//
//  Created by Ina Statkic on 07/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class AuthFlowController: FlowController {
    
    func goToSignIn() {
        let vc = SignInViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    func pushToSignIn() {
        let vc = SignInViewController.instantiate(storyboard: "Auth")
        currentViewController.navigationController?.pushViewController(vc, animated: false)
    }
    
    func goToForgotPassword() {
        let vc = ForgotPasswordViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    func goToList() {
        UIWindow.keyWindow?.rootViewController = TabBarController()
    }
    
    func showSuccess() {
        let vc = SuccessAlertViewController.instantiate(storyboard: "Success")
        vc.success = .resetPasswordLinkSent
        currentViewController.present(vc, animated: true)
    }
    
    #if PRO
    
    func goToSignUp() {
        let vc = SignUpViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    func pushToSignUp() {
        let vc = SignUpViewController.instantiate(storyboard: "Auth")
        currentViewController.navigationController?.pushViewController(vc, animated: false)
    }
    
    func goToCompleteSign() {
        let vc = CompleteSignViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    func goToList(_ targetRole: User.Role) {
        let tbc = TabBarController()
        tbc.role = targetRole
        UIWindow.keyWindow?.rootViewController = tbc
    }
    
    #elseif USER
    
    func goToBook(venue: Venue) {
        let tbc = TabBarController()
        UIWindow.keyWindow?.rootViewController = tbc
        let vc = BookViewController.instantiate(storyboard: "Book")
        vc.venue = venue
        tbc.present(vc, animated: true)
    }
    
    func goToSignUpUser() {
        let vc = SignUpUserViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    func pushToSignUpUser() {
        let vc = SignUpUserViewController.instantiate(storyboard: "Auth")
        currentViewController.navigationController?.pushViewController(vc, animated: false)
    }
    
    func goToPhoneVerification() {
        let vc = PhoneVerificationViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    func goToCodePhoneVerification() {
        let vc = CodePhoneVerificationViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    #endif
}
