//
//  AuthNavigationController.swift
//  vennu
//
//  Created by Ina Statkic on 07/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class AuthNavigationController: UINavigationController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - Setup
    
    private func setNavigationBar() {
        navigationBar.backIndicatorImage = UIImage()
        navigationBar.backIndicatorTransitionMaskImage = UIImage()
        navigationBar.tintColor = .coralRed
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92]
    }
}
