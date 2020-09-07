//
//  TermsConditionsViewController.swift
//  vennu
//
//  Created by Ina Statkic on 12/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit


final class TermsConditionsViewController: DocumentViewController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TERMS AND CONDITIONS"
        document("Terms&Conditions.pdf")
    }
    
}
