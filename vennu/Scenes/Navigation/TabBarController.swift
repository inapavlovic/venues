//
//  ListTabBarController.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: Properties
    
    let appearance = UITabBarAppearance()
    let itemAppearance = UITabBarItemAppearance()
    
    var role: User.Role?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupTabBar()
    }
    
    // MARK: - Setup
    
    private func setupTabBar() {
        appearance.backgroundColor = .white
        appearance.shadowColor = .none
        
        itemAppearance.normal.iconColor = .coralRed
        itemAppearance.selected.iconColor = .coralRed
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.coralRed]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        
        #if PRO
        
        let listVC = ListViewController.instantiate(storyboard: "List")
        let listNC = ListNavigationController(rootViewController: listVC)
        let bookingsVC = BookingsViewController()
        let bookingsNC = BookNavigationController(rootViewController: bookingsVC)
        let activityVC = ActivityViewController()
        let profileVC = ProfileViewController.instantiate(storyboard: "Profile")
        let settingsVC = SettingsViewController()
        let settingsNC = ListNavigationController(rootViewController: settingsVC)
        
        let list = UITabBarItem(title: "Listings", image: UIImage(named: "doc.text"), tag: 0)
        let book = UITabBarItem(title: "Bookings", image: UIImage(named: "calendar"), tag: 1)
        let activity = UITabBarItem(title: "Activity", image: UIImage(named: "bell"), tag: 2)
        let profile = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 3)
        let settings = UITabBarItem(title: "Settings", image: UIImage(named: "gear"), tag: 4)

        listVC.tabBarItem = list
        bookingsVC.tabBarItem = book
        activityVC.tabBarItem = activity
        profileVC.tabBarItem = profile
        settingsVC.tabBarItem = settings
        
        viewControllers = [listNC, bookingsNC, activityVC, profileVC, settingsNC]
            
        if role == User.Role.admin {

            let searchVC = SearchListViewController.instantiate(storyboard: "SearchList")
            let searchNC = ListNavigationController(rootViewController: searchVC)
            let bookingsVC = BookingsViewController()
            let bookingsNC = BookNavigationController(rootViewController: bookingsVC)
            let profileVC = ProfileViewController.instantiate(storyboard: "Profile")
            let manageVC = ManageViewController.instantiate(storyboard: "Manage")
            let manageNC = ListNavigationController(rootViewController: manageVC)
            let settingsVC = SettingsViewController()
            let settingsNC = ListNavigationController(rootViewController: settingsVC)
            
            let search = UITabBarItem(title: "Explore", image: UIImage(named: "search"), tag: 0)
            let book = UITabBarItem(title: "Bookings", image: UIImage(named: "calendar"), tag: 1)
            let profile = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 2)
            let manage = UITabBarItem(title: "Manage", image: UIImage(named: "manage"), tag: 3)
            let settings = UITabBarItem(title: "Settings", image: UIImage(named: "gear"), tag: 4)

            searchVC.tabBarItem = search
            bookingsVC.tabBarItem = book
            manageVC.tabBarItem = manage
            profileVC.tabBarItem = profile
            settingsVC.tabBarItem = settings
            
            viewControllers = [searchNC, bookingsNC, profileVC, manageNC, settingsNC]
            
        }
        
        #elseif USER
        
        let exploreVC = ExploreViewController.instantiate(storyboard: "List")
        let exploreNC = ListNavigationController(rootViewController: exploreVC)
        let bookingsVC = BookingsViewController()
        let bookingsNC = ListNavigationController(rootViewController: bookingsVC)
        let profileVC = ProfileViewController.instantiate(storyboard: "Profile")
        let settingsVC = SettingsViewController()
        let settingsNC = ListNavigationController(rootViewController: settingsVC)
        
        let explore = UITabBarItem(title: "Explore", image: UIImage(named: "search"), tag: 0)
        let book = UITabBarItem(title: "Bookings", image: UIImage(named: "calendar"), tag: 1)
        let profile = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 3)
        let settings = UITabBarItem(title: "Settings", image: UIImage(named: "gear"), tag: 4)

        exploreNC.tabBarItem = explore
        bookingsVC.tabBarItem = book
        profileVC.tabBarItem = profile
        settingsVC.tabBarItem = settings
        
        viewControllers = [exploreNC, bookingsNC, profileVC, settingsNC]
        
        #endif
    }

}
