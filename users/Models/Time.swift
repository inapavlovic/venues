//
//  Time.swift
//  users
//
//  Created by Ina Statkic on 03/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

enum Time {
    static var all: [String] = {
        let am = stride(from: 1, through: 12, by: 1).map { "\($0)AM" }
        let pm = stride(from: 1, through: 12, by: 1).map { "\($0)PM" }
        return am + pm
    }()
    
    static var index: [Int] = {
        let hours = stride(from: 0, through: 23, by: 1).map { $0 }
        return hours
    }()
}
