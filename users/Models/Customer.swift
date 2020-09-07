//
//  Customer.swift
//  users
//
//  Created by Ina Statkic on 16/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

struct Customer: Codable {
    var id: String?
    var name: String?
    var email: String?
    var description: String?
    var card: String?
    
    private enum CodingKeys: String, CodingKey {
        case card = "default_source"
    }
}

struct CustomerResponse: Decodable {
    let data: Customer
}
