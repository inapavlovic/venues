//
//  STPTheme.swift
//  users
//
//  Created by Ina Statkic on 07/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation
import Stripe

extension STPTheme {
    static func configure() {
        self.defaultTheme.accentColor = .coralRed
        self.defaultTheme.primaryBackgroundColor = .desertStorm
        self.defaultTheme.secondaryForegroundColor = .tuna
        self.defaultTheme.primaryForegroundColor = .tuna
        self.defaultTheme.secondaryBackgroundColor = .clear
        self.defaultTheme.font = UIFont.systemFont(ofSize: 14)
    }
}
