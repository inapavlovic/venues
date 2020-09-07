//
//  Date.swift
//  vennu
//
//  Created by Ina Statkic on 26/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

extension Date {
    func ago(_ postedTime: Date? = nil) -> String {
        let dayDifference = Calendar.current.dateComponents([.year, .month, .day, .minute], from: self, to: Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.timeStyle = .none
        timeFormatter.dateFormat = "hh:mm"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateStyle = .short
        dayFormatter.timeStyle = .none
        dayFormatter.dateFormat = "EEE"
        
        if let year = dayDifference.year, let day = dayDifference.day, let minute = dayDifference.minute {
            if year == 0 && day == 0 && minute < 10 {
                return "A few moments ago"
            } else if year == 0 && day == 0 {
                return "Today at " + timeFormatter.string(from: postedTime ?? Date())
            } else if year == 0 && day == 1 {
                return "Yesterday at " + timeFormatter.string(from: postedTime ?? Date())
            } else if year == 0 && (day >= 2 || day <= 7) {
                return dayFormatter.string(from: postedTime ?? Date()) + " at " + timeFormatter.string(from: postedTime ?? Date())
            } else if year == 0 && day > 7 {
                return "Some time ago"
            } else {
                return "Some time ago"
            }
        } else {
            return "Some time ago"
        }
    }
    
    func startTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    func dMMM() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        return dateFormatter.string(from: self)
    }
    
    func monthLLLL() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("LLLL")
        return dateFormatter.string(from: self)
    }
    
    func ddyyyy() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("ddyyyy")
        return dateFormatter.string(from: self)
    }
    
    func daysHours(to date: Date) -> (Int, Int) {
        let dateComponent = Calendar.current.dateComponents([.day, .hour], from: Date(), to: date)
        return (dateComponent.day!, dateComponent.hour!)
    }
    
    func time() -> Date? {
        let calendar = Calendar.current
        let time = calendar.dateComponents([.hour], from: self)
        var dateComponents = DateComponents()
        dateComponents.hour = time.hour
        return calendar.date(byAdding: dateComponents, to: self)
    }
}
