//
//  RoomDetailFlowController.swift
//  vennu
//
//  Created by Ina Statkic on 14.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit

class RoomDetailFlowController: FlowController {
    
    #if PRO
    
    func goToEditVenue(_ venue: Venue?) {
        let vc = AddVenueViewController.instantiate(storyboard: "List")
        vc.venue = venue
        let nc = ListNavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        currentViewController.present(nc, animated: true)
    }
    
    func goToList() {
        UIWindow.keyWindow?.rootViewController = TabBarController()
    }
    
    func backToSearchList() {
        let tbc = TabBarController()
        tbc.role = .admin
        UIWindow.keyWindow?.rootViewController = tbc
    }
    
    #elseif USER
    
    func goToExplore() {
        UIWindow.keyWindow?.rootViewController = TabBarController()
    }
    
    func requestedAssistance() {
        let vc = SuccessAlertViewController.instantiate(storyboard: "Success")
        vc.success = .requestedAssistance
        currentViewController.present(vc, animated: true)
    }
    
    #endif
    
    func goToPhoto(_ image: URL) {
        let vc = PhotoViewController.instantiate(storyboard: "RoomDetail")
        vc.image = image
        vc.modalPresentationStyle = .fullScreen
        currentViewController.present(vc, animated: true)
    }
}
