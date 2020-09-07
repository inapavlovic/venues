//
//  UserDefaults.swift
//  users
//
//  Created by Ina Statkic on 19/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

extension UserDefaults {
    private enum Key : String {
        case funding
        case last4
        case cardId
        case admin
    }
    
    private static var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    static var funding: String {
        get {
            return defaults.string(forKey: Key.funding.rawValue) ?? ""
        }
        set(value) {
            defaults.set(value, forKey: Key.funding.rawValue)
        }
    }
    
    static var last4: String {
        get {
            return defaults.string(forKey: Key.last4.rawValue) ?? ""
        }
        set(value) {
            defaults.set(value, forKey: Key.last4.rawValue)
        }
    }
    
    static var cardId: String {
        get {
            return defaults.string(forKey: Key.cardId.rawValue) ?? ""
        }
        set(value) {
            defaults.set(value, forKey: Key.cardId.rawValue)
        }
    }
    
    static var admin: Bool {
        get {
            return defaults.bool(forKey: Key.admin.rawValue) 
        }
        set(value) {
            defaults.set(value, forKey: Key.admin.rawValue)
        }
    }

}
