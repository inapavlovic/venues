//
//  String.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

extension String {
    
    func first() -> String {
        let words = self.split(separator: " ")
        let word = String(words.first ?? "")
        return word
    }
    
    func last() -> String {
        let words = self.split(separator: " ")
        if words.count > 1 {
            return String(words.last ?? "")
        } else {
            return ""
        }
    }
    
    func shortDuration() -> String {
        let s = self.split(separator: "(")
        if s.count > 1 {
            return String(s.first ?? "")
        } else {
            return ""
        }
    }
    
    func street() -> String {
        let parts = self.split(separator: ",")
        return String(parts.first ?? "")
    }
    
    /// Format phone number, e.g. +44 123 123 123
    func formatPhoneNumber() -> String {
        guard !self.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let range = NSString(string: self).range(of: self)
        var number = regex.stringByReplacingMatches(in: self, options: .init(rawValue: 0), range: range, withTemplate: "")
        
        let numberRange = number.startIndex..<number.index(number.startIndex, offsetBy: number.count)
        if number.count < 5 {
            number = number.replacingOccurrences(of: "(\\d{2})(\\d+)", with: "$1 $2", options: .regularExpression, range: numberRange)
        } else {
            number = number.replacingOccurrences(of: "(\\d{2})(\\d{3})(\\d{3})(\\d+)", with: "$1 $2 $3 $4", options: .regularExpression, range: numberRange)
        }
        return number
    }
    
    func isValidEmail() -> Bool? {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    /// Check if contains any character from a to z, special character, number and six characters long
    func isValidPassword() -> Bool? {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[0-9])(?=.*[!\"#$%&'()*+,-./:;=>?@\\^_`{|}~])(?=.*[A-Z]).{6,}$")
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func highlight(rangeValues: [NSValue]) -> NSAttributedString {
        let highlighted = NSMutableAttributedString(string: self)
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.tuna]
        let ranges = rangeValues.map { $0.rangeValue }
        ranges.forEach {
            highlighted.addAttributes(attributes, range: $0)
        }
        return highlighted
    }
}
