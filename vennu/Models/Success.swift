//
//  Success.swift
//  vennu
//
//  Created by Ina Statkic on 06/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

enum Success: Equatable {
    case createdVenue
    case updatedVenue
    case updatedProfile
    case resetPasswordLinkSent
    case paymentComplete(String)
    case updatedCateringInfo
    case updatedBookingFee
    case requestedAssistance
    
    /// A user-presentable success message
    var text: String {
        switch self {
        case .createdVenue: return "Venue successfully published"
        case .updatedVenue: return "Venue successfully updated"
        case .updatedProfile: return "Profile successfully updated"
        case .resetPasswordLinkSent: return "Reset password link sent"
        case .paymentComplete(let message): return message
        case .updatedCateringInfo: return "Catering successfully updated"
        case .updatedBookingFee: return "Booking fee successfully updated"
        case .requestedAssistance: return "Assistance requested"
        }
    }
}
