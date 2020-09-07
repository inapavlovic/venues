//
//  PresentViewController.swift
//  vennu
//
//  Created by Ina Statkic on 12/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        set()
    }
    
    // MARK: - Set
    
    private func set() {
        view.backgroundColor = .white

        if view.frame.width >= 375 {
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        } else {
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        }
    }
}
