//
//  ProfileFlowController.swift
//  vennu
//
//  Created by Ina Statkic on 06/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

class ProfileFlowController: FlowController {
    func showSuccess() {
        let vc = SuccessAlertViewController.instantiate(storyboard: "Success")
        vc.success = .updatedProfile
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        currentViewController.present(vc, animated: true)
    }
}
