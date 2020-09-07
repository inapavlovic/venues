//
//  PresentNavigationController.swift
//  vennu
//
//  Created by Ina Statkic on 12/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class PresentNavigationController: ListNavigationController {
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }

    // MARK: - Set
    
    private func setNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
