//
//  Duration.swift
//  users
//
//  Created by Ina Statkic on 13/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

enum Duration {
    static func type(pricing: Pricing) -> [PricingType] {
        let hours = stride(from: 1, through: 4, by: 1).map {
            $0 == 4 ? PricingType.halfDay(pricing.halfDay) : PricingType.hourly(pricing.hourly)
        }
        let days = stride(from: 1, through: 10, by: 1).map { _ in
            PricingType.fullDay(pricing.fullDay) }
        return hours + days
    }
    
    static var all: [String] = {
        let hours = stride(from: 1, through: 4, by: 1).map { "\($0)H" }
        let days = stride(from: 1, through: 10, by: 1).map { $0 == 1 ? "\($0)DAY" : "\($0)DAYS" }
        return hours + days
    }()
    
    static func price(pricing: Pricing) -> [Double] {
        let hours = stride(from: 1, through: 4, by: 1).map {
            $0 == 4 ? $0 * PricingType.halfDay(pricing.halfDay).value : $0 * PricingType.hourly(pricing.hourly).value
        }
        let days = stride(from: 1, through: 10, by: 1).map { $0 * PricingType.fullDay(pricing.fullDay).value }
        return hours + days
    }
    
    static func end(date: Date) -> [Date] {
        let calendar = Calendar.current
        let hours = stride(from: 1, through: 4, by: 1).map {
            calendar.date(byAdding: .hour, value: $0, to: date)!
        }
        let days = stride(from: 1, through: 10, by: 1).map {
            calendar.date(byAdding: .day, value: $0, to: date)!
        }
        return hours + days
    }
    
    static var index: [Int] = {
        let index = stride(from: 0, through: 13, by: 1).map { $0 }
        return index
    }()
}
