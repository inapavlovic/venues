//
//  Settings.swift
//  vennu
//
//  Created by Ina Statkic on 14/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

enum Settings: CaseIterable, Equatable {
    case notifications(Bool)
    case privacyPolicy
    case termsConditions
    case rate
    case share
    case sign
    case techSupport
    case customerSupport
    
    /// A user-presentable name
    var name: String {
        switch self {
        case .notifications: return "Notifications"
        case .privacyPolicy: return "Privacy Policy"
        case .termsConditions: return "Terms & Conditions"
        case .rate: return "Rate on the AppStore"
        case .share: return "Share App"
        case .techSupport: return "Tech Support"
        case .customerSupport: return "Customer Support"
        case .sign: return FirebaseManager.shared.currentUser != nil ? "Log out" : "Login"
        }
    }
    
    /// The associated image
    var image: UIImage {
        let name: String
        switch self {
        case .notifications(let value): name = value ? "bell" : "bell.slash"
        case .privacyPolicy: name = "info"
        case .termsConditions: name = "info"
        case .rate: name = "star"
        case .share: name = "share"
        case .techSupport: name = "arrow.up.right.square"
        case .customerSupport: name = "arrow.up.right.square"
        case .sign: name = "arrow.up.right.square"
        }
        return UIImage(named: name)!
    }
    
    static var allCases: [Settings] {
        return [.notifications(true), .privacyPolicy, .termsConditions, .rate, .share, .techSupport, .customerSupport, .sign]
    }
}
