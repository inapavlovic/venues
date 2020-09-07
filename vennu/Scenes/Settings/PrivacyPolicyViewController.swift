//
//  PrivacyViewController.swift
//  vennu
//
//  Created by Ina Statkic on 12/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import WebKit

final class PrivacyPolicyViewController: DocumentViewController {
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "PRIVACY POLICY"
        document("PrivacyPolicy.pdf")
    }
    
}
