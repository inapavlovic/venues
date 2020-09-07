//
//  BaseViewController.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Controls
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation()
        setActivityIndicator()
    }
    
    // MARK: - Set
    
    private func setActivityIndicator() {
        activityIndicatorView = UIActivityIndicatorView(frame: view.frame)
        view.addSubview(activityIndicatorView)
    }
    
    private func setNavigation() {
        navigationItem.setHidesBackButton(true, animated: false)
    }
}
