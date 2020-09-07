//
//  NumberFormatter.swift
//  vennu
//
//  Created by Ina Statkic on 18/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = true
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 0
        return numberFormatter
    }()
}
