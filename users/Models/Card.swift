//
//  Card.swift
//  users
//
//  Created by Ina Statkic on 12/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

struct CardParams: Codable {
    var cardNumber: String
    var expireMonth: Int
    var expireYear: Int
    var cvc: String
}

struct TokenResponse: Decodable {
    let data: Token
}

struct Token: Decodable {
    var id: String
    var card: Card
}

struct Card: Decodable {
    var id: String
    var funding: String
    var last4: String
}

struct AddCard: Encodable {
    var customerId: String
    var source: String
}

struct CardResponse: Decodable {
    let data: Card
}

struct UpdateCard: Encodable {
    var customerId: String
    var source: String
    
    enum CodingKeys: String, CodingKey {
        case source = "defaultSource"
        case customerId
    }
}
