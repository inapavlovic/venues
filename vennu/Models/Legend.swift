//
//  Legend.swift
//  vennu
//
//  Created by Ina Statkic on 13.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

enum Legend: String, CaseIterable {
    case fullDay
    case halfDay
    case fewHours
    case oneHour
    
    var color: UIColor {
        switch self {
        case .fullDay: return UIColor.coralRed
        case .halfDay: return UIColor.saftyOrange
        case .fewHours: return UIColor.tuna
        case .oneHour: return UIColor.pumice
        }
    }
}
