//
//  SettingsFlowController.swift
//  vennu
//
//  Created by Ina Statkic on 09/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class SettingsFlowController: FlowController {
    
    func goToAuth() {
        let vc = SignInViewController.instantiate(storyboard: "Auth")
        let nc = AuthNavigationController(rootViewController: vc)
        UIWindow.keyWindow?.rootViewController = nc
    }
    
    func goToExplore() {
        UIWindow.keyWindow?.rootViewController = TabBarController()
    }
    
    func viewPrivacyPolicy() {
        let vc = PrivacyPolicyViewController()
        currentViewController.show(vc, sender: self)
    }
    
    func readTermsAndConditions() {
        let vc = TermsConditionsViewController()
        currentViewController.show(vc, sender: self)
    }
}
