//
//  Rating.swift
//  vennu
//
//  Created by Ina Statkic on 23/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

struct Review: Decodable {
    var author: String
    var text: String

    /// Mock reviews
    static var reviews: [Review] {
        return [
            Review(author: "John Doe", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.")
        ]
    }
}

struct Rate: Decodable {
    var name: String
    var stars: Int
}
