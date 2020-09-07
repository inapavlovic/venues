//
//  ListNavigationController.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class ListNavigationController: UINavigationController {
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - Set
    
    private func setNavigationBar() {
        navigationBar.tintColor = .coralRed
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 12), .kern : 0.92]
    }
}
