//
//  Charge.swift
//  users
//
//  Created by Ina Statkic on 11/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

struct Payment: Codable {
    var source: String
    var amount: Int
    var customer: String
}

struct Book: Codable {
    var stripe: Payment
    var booking: Booking
}

struct BookResponseContainer: Decodable {
    let data: BookResponse
}

struct BookResponse: Decodable {
    var outcome: Outcome
}

struct Outcome: Decodable {
    var message: String
    
    private enum CodingKeys: String, CodingKey {
        case message = "seller_message"
    }
}

