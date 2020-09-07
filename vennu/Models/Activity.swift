//
//  Activity.swift
//  vennu
//
//  Created by Ina Statkic on 26/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

struct Activity: Hashable, Decodable {
    var id: String
    var customer: String
    var userId: String
    var venueId: String
    var uidVenue: String
    var title: String
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
