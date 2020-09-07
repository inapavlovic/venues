//
//  User.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

final class User: Codable {
    
    enum Role: String, Codable {
        case pro
        case user
        case admin
    }
    
    var uid: String
    var role: Role
    var name: String
    var email: String
    
    var address: String?
    var businessName: String?
    var companyID: Int?
    var phoneNumber: String?
    
    var notifications: Bool? = true
    
    var customerId: String?
    
    enum UserKeys: CodingKey {
        case uid
        case role
        case name
        case email
        case address
        case businessName
        case companyID
        case phoneNumber
        case notifications
        case customerId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        role = try container.decode(Role.self, forKey: .role)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        businessName = try container.decodeIfPresent(String.self, forKey: .businessName)
        companyID = try container.decodeIfPresent(Int.self, forKey: .companyID)
        phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        notifications = try container.decodeIfPresent(Bool.self, forKey: .notifications)
        customerId = try container.decodeIfPresent(String.self, forKey: .customerId)
    }
}
