//
//  FlowController.swift
//  vennu
//
//  Created by Ina Statkic on 07/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit.UIViewController

class FlowController {
    
    // MARK: Properties
    
    unowned var currentViewController: UIViewController
    
    // MARK: - Init
    
    init(_ currentViewController: UIViewController) {
        self.currentViewController = currentViewController
    }
}
