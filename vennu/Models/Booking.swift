//
//  Booking.swift
//  vennu
//
//  Created by Ina Statkic on 26/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation

enum CateringSegment: String, CaseIterable {
    case premium
    case basic
}

struct CateringPrice: Decodable {
    var basic: Double = 0
    var basicInfo: String = ""
    var premium: Double = 0
    var premiumInfo: String = ""
    
    enum CodingKeys: String, CodingKey {
        case basic
        case basicInfo = "basic_info"
        case premium
        case premiumInfo = "premium_info"
    }
}

struct Catering: Hashable, Codable {
    var basic: Int? = 0
    var premium: Int? = 0
}

struct Booking: Hashable, Codable {
    var id: String?
    var uid: String? = FirebaseManager.shared.uid
    var customer: String?
    var venueId: String?
    var uidVenue: String?
    var title: String?
    var startDate: TimeInterval?
    var endDate: TimeInterval?
    var startTime: String?
    var duration: String?
    var catering: Catering? = Catering()
    var notes: String? = ""
    var bookDate: TimeInterval?
    
    var rentPrice: Double?
    var cateringPrice: Double = 0
    var fee: Double = 0
    var total: Int? {
        return Int((rentPrice! + cateringPrice + fee) * 100)
    }
    
    private enum CodingKeys: String, CodingKey {
        case uid = "userId"
        case venueId = "vennuId"
        case uidVenue
        case title
        case startDate
        case endDate
        case notes
        case duration
        case bookDate
        case catering
        case rentPrice
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(venueId, forKey: .venueId)
        try container.encode(uid, forKey: .uid)
        try container.encode(title, forKey: .title)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(notes, forKey: .notes)
        try container.encode(duration, forKey: .duration)
        try container.encode(bookDate, forKey: .bookDate)
        try container.encode(catering, forKey: .catering)
    }
    
    static func == (lhs: Booking, rhs: Booking) -> Bool {
        return lhs.id == rhs.id
    }
}
