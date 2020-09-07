//
//  ListFlowController.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class ListFlowController: FlowController {
    
    #if USER
    
    func goToSearchList(searchText: String, numberOfPeople: Int) {
        let vc = SearchListViewController.instantiate(storyboard: "SearchList")
        vc.searchText = searchText
        vc.numberOfPeople = numberOfPeople
        currentViewController.show(vc, sender: self)
    }
    
    func goToExplore() {
        UIWindow.keyWindow?.rootViewController = TabBarController()
    }
    
    func backToList(searchText: String, numberOfPeople: Int) {
        let vc = currentViewController.navigationController?.viewControllers[1] as! SearchListViewController
        vc.searchText = searchText
        vc.numberOfPeople = numberOfPeople
        currentViewController.navigationController?.popToViewController(vc, animated: true)
    }
    
    func goToFacilities(_ facilities: [String]?) {
        let vc = FacilitiesViewController()
        vc.delegate = currentViewController as? SearchListViewController
        vc.venueFacilities = facilities
        let nc = PresentNavigationController(rootViewController: vc)
        currentViewController.present(nc, animated: true)
    }
    
    func goToBook(venue: Venue) {
        let vc = BookViewController.instantiate(storyboard: "Book")
        vc.venue = venue
        currentViewController.present(vc, animated: true)
    }
    
    func goToSignIn() {
        let vc = SignInViewController.instantiate(storyboard: "Auth")
        currentViewController.show(vc, sender: self)
    }
    
    func showSuccess(message: String) {
        let vc = SuccessAlertViewController.instantiate(storyboard: "Success")
        vc.success = .paymentComplete(message)
        currentViewController.present(vc, animated: true)
    }
    
    func showRating(venue: Venue) {
        let vc = RateViewController.instantiate(storyboard: "RoomDetail")
        vc.venue = venue
        currentViewController.present(vc, animated: true)
    }
    
    #elseif PRO
    
    func goToAddVenue(_ venue: Venue?) {
        let vc = AddVenueViewController.instantiate(storyboard: "List")
        vc.venue = venue
        currentViewController.show(vc, sender: self)
    }
    
    func goToAddFeatures(_ features: [String]?) {
        let vc = FeaturesViewController()
        vc.delegate = currentViewController as? AddVenueViewController
        vc.venueFeatures = features
        let nc = PresentNavigationController(rootViewController: vc)
        currentViewController.present(nc, animated: true)
    }
    
    func goToAddCapacity(_ capacity: Capacity?) {
        let vc = CapacityViewController()
        vc.delegate = currentViewController as? AddVenueViewController
        vc.venueCapacity = capacity
        let nc = PresentNavigationController(rootViewController: vc)
        currentViewController.present(nc, animated: true)
    }
    
    func goToAddFacilities(_ facilities: [String]?) {
        let vc = FacilitiesViewController()
        vc.delegate = currentViewController as? AddVenueViewController
        vc.venueFacilities = facilities
        let nc = PresentNavigationController(rootViewController: vc)
        currentViewController.present(nc, animated: true)
    }
    
    func goToAddPricing(_ pricing: Pricing?) {
        let vc = PricingViewController()
        vc.delegate = currentViewController as? AddVenueViewController
        vc.venuePricing = pricing
        let nc = PresentNavigationController(rootViewController: vc)
        currentViewController.present(nc, animated: true)
    }
    
    func showSuccess(_ venueRequest: VenueRequest, success: Success, venue: Venue?) {
        let vc = SuccessAlertViewController.instantiate(storyboard: "Success")
        vc.venueRequest = venueRequest
        vc.venue = venue
        vc.success = success
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        currentViewController.present(vc, animated: true)
    }
    
    func goToList() {
        UIWindow.keyWindow?.rootViewController = TabBarController()
    }
    
    func goToProfile() {
        let tbc = TabBarController()
        UIWindow.keyWindow?.rootViewController = tbc
        tbc.selectedIndex = 3
    }

    func goToFacilities(_ facilities: [String]?) {
        let vc = FacilitiesViewController()
        vc.delegate = currentViewController as? SearchListViewController
        vc.venueFacilities = facilities
        let nc = PresentNavigationController(rootViewController: vc)
        currentViewController.present(nc, animated: true)
    }
    
    func backToList(searchText: String, numberOfPeople: Int) {
        let vc = currentViewController.navigationController?.viewControllers[0] as! SearchListViewController
        vc.searchText = searchText
        vc.numberOfPeople = numberOfPeople
        currentViewController.navigationController?.popToViewController(vc, animated: true)
    }
    
    #endif
}

extension ListFlowController {
    func goToMap(searchText: String, numberOfPeople: Int) {
        let vc = MapViewController.instantiate(storyboard: "SearchList")
        vc.searchText = searchText
        vc.numberOfPeople = numberOfPeople
        currentViewController.show(vc, sender: self)
    }

    func goToRoomDetail(venue: Venue) {
        let vc = RoomDetailViewController.instantiate(storyboard: "RoomDetail")
        vc.venue = venue
        currentViewController.present(vc, animated: true)
    }

    func goToVenueDetails(_ venue: Venue?, context: VenueDetailsContext) {
        let vc = VenueDetailsViewController.instantiate(storyboard: "RoomDetail")
        vc.venue = venue
        vc.context = context
        let nc = ListNavigationController(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        currentViewController.present(nc, animated: true)
    }
}
