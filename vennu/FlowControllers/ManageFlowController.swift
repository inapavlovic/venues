//
//  ManageFlowController.swift
//  vennu
//
//  Created by Ina Statkic on 23.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

class ManageFlowController: FlowController {
    func showSuccess(success: Success) {
        let vc = SuccessAlertViewController.instantiate(storyboard: "Success")
        vc.success = success
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        currentViewController.present(vc, animated: true)
    }
}
