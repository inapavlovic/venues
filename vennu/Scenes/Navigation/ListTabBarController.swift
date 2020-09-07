//
//  ListTabBarController.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupTabBar()
    }
    
    // MARK: - Setup
    
    private func setupTabBar() {
        let listVC = UIStoryboard(name: "List", bundle: nil).instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        let bookVC = UIStoryboard(name: "Book", bundle: nil).instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
        let activityVC = UIStoryboard(name: "Activity", bundle: nil).instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        let list = UITabBarItem(title: "Listings", image: UIImage(systemName: "doc.text"), tag: 0)
        let book = UITabBarItem(title: "Bookings", image: UIImage(systemName: "calendar"), tag: 1)
        let activity = UITabBarItem(title: "Activity", image: UIImage(systemName: "bell"), tag: 2)
        let profile = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        let settings = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)

        listVC.tabBarItem = list
        bookVC.tabBarItem = book
        activityVC.tabBarItem = activity
        profileVC.tabBarItem = profile
        settingsVC.tabBarItem = settings
        
        let controllers = [listVC, bookVC, activityVC, profileVC, settingsVC]
        viewControllers = controllers
    }

}
