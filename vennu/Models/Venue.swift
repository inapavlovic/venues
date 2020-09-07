//
//  Venue.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

enum FeatureType: CaseIterable {
    case businessLounge
    case videoconferencingStudio
    case dayAccess
    case cityTownCentre
    case outsideSeatingAreaTerrace
    
    /// A user-presentable name
    var name: String {
        switch self {
        case .businessLounge: return "Business Lounge"
        case .videoconferencingStudio: return "Videoconferencing Studio"
        case .dayAccess: return "24 Hour Access"
        case .cityTownCentre: return "City/Town Centre"
        case .outsideSeatingAreaTerrace: return "Outside Seating Area/Terrace"
        }
    }
    
    var index: Int {
        switch self {
        case .businessLounge: return 0
        case .videoconferencingStudio: return 1
        case .dayAccess: return 2
        case .cityTownCentre: return 3
        case .outsideSeatingAreaTerrace: return 4
        }
    }
}

enum FacilityType: CaseIterable {
    case wifi
    case projectorScreen
    case flipchart
    case conferenceCallFacilities
    case parkingAvailable
    case airConditioning
    case disabledAccess
    case storageSpace
    case basicStationary
    case coffeAndTea

    /// A user-presentable name
    var name: String {
        switch self {
        case .wifi: return "Wi-Fi"
        case .projectorScreen: return "Projector/screen"
        case .flipchart: return "Flipchart"
        case .conferenceCallFacilities: return "Conference call facilities"
        case .parkingAvailable: return "Parking available"
        case .airConditioning: return "Air conditioning"
        case .disabledAccess: return "Disabled access"
        case .storageSpace: return "Storage space"
        case .basicStationary: return "Basic stationary"
        case .coffeAndTea: return "Coffe & Tea"
        }
    }
    
    /// The associated image
    var image: UIImage {
        let name: String
        switch self {
        case .wifi: name = "wifi"
        case .projectorScreen: name = "projector"
        case .flipchart: name = "flipchart"
        case .conferenceCallFacilities: name = "video"
        case .parkingAvailable: name = "p.square"
        case .airConditioning: name = "air.condition"
        case .disabledAccess: name = "disabled.access"
        case .storageSpace: name = "storage"
        case .basicStationary: name = "stationary"
        case .coffeAndTea: name = "coffee&tea"
        }
        
        return UIImage(named: name)!
    }
    
    var index: Int {
        switch self {
        case .wifi: return 0
        case .projectorScreen: return 1
        case .flipchart: return 2
        case .conferenceCallFacilities: return 3
        case .parkingAvailable: return 4
        case .airConditioning: return 5
        case .disabledAccess: return 6
        case .storageSpace: return 7
        case .basicStationary: return 8
        case .coffeAndTea: return 9
        }
    }
}

enum CapacityType: CaseIterable {
    case standing(Int)
    case theatre(Int)
    case dining(Int)
    case boardroom(Int)
    case uShaped(Int)
    
    /// A user-presentable name
    var name: String {
        switch self {
        case .standing: return "Standing"
        case .theatre: return "Theatre"
        case .dining: return "Dining"
        case .boardroom: return "Boardroom"
        case .uShaped: return "U-Shaped"
        }
    }
    
    var tag: Int {
        switch self {
        case .standing: return 0
        case .theatre: return 1
        case .dining: return 2
        case .boardroom: return 3
        case .uShaped: return 4
        }
    }
    
    /// The associated value
    var value: Int {
        switch self {
        case .standing(let value): return value
        case .theatre(let value): return value
        case .dining(let value): return value
        case .boardroom(let value): return value
        case .uShaped(let value): return value
        }
    }
    
    static var allCases: [CapacityType] {
        return [.standing(0), .theatre(0), .dining(0), .boardroom(0), .uShaped(0)]
    }
}

enum PricingType: CaseIterable {
    case hourly(Double)
    case halfDay(Double)
    case fullDay(Double)
    case multiDay(Double)
    
    /// A user-presentable name
    var name: String {
        switch self {
        case .hourly: return "Hourly"
        case .halfDay: return "Half-Day(4hours)"
        case .fullDay: return "Full-Day(8hours)"
        case .multiDay: return "Multi-Day"
        }
    }
    
    var tag: Int {
        switch self {
        case .hourly: return 0
        case .halfDay: return 1
        case .fullDay: return 2
        case .multiDay: return 3
        }
    }
    
    /// The associated price
    var value: Double {
        switch self {
        case .hourly(let value): return value
        case .halfDay(let value): return value
        case .fullDay(let value): return value
        case .multiDay(let value): return value
        }
    }
    
    /// A user-presentable price
    var userValue: String {
        switch self {
        case .hourly(let value): return "£\(Decimal(value))/per hour"
        case .halfDay(let value): return "£\(Decimal(value))"
        case .fullDay(let value): return "£\(Decimal(value))"
        case .multiDay(let value): return "£\(Decimal(value))/per day"
        }
    }
    
    static var allCases: [PricingType] {
        return [.hourly(0), .halfDay(0), .fullDay(0), .multiDay(0)]
    }
}

struct Capacity: Decodable {
    var standing: Int
    var theatre: Int
    var dining: Int
    var boardroom: Int
    var uShaped: Int
    
    var numberOfPeople: Int {
        standing + theatre + dining + boardroom + uShaped
    }
}

struct Facility {
    var image: UIImage
    var name: String
}

struct Pricing: Decodable {
    var hourly: Double
    var halfDay: Double
    var fullDay: Double
    var multiDay: Double
}

// MARK: - Venue

struct VenueRequest {
    var title: String = ""
    var address: String = ""
    var location: String = ""
    var description: String?
    var photos: [UIImage] = []
    var features: [String]?
    var facilities: [String]?
    var capacity: Capacity?
    var pricing: Pricing?
    
    func validate() throws {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidateError.titleEmpty
        }
        if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidateError.addressEmpty
        }
        if photos.isEmpty {
            throw ValidateError.photosEmpty
        }
    }
    
    enum ValidateError: Error {
        case titleEmpty
        case addressEmpty
        case photosEmpty
        
        var localizedDescription: String {
            switch self {
            case .titleEmpty: return "Please enter title."
            case .addressEmpty: return "Please enter address."
            case .photosEmpty: return "Please add photos."
            }
        }
    }
}

struct Venue: Equatable, Hashable, Decodable {
    var id: String
    var uid: String
    var title: String
    var address: String
    var location: String
    var description: String
    var photos: [URL]
    var features: [String]
    var capacity: Capacity
    var facilities: [String]
    var pricing: Pricing
    var popular: Bool
    var reviews: [Review]
    var rates: [Rate]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case uid
        case title
        case address
        case location
        case description
        case photos
        case features
        case capacity
        case facilities
        case pricing
        case popular
        case reviews
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        uid = try container.decode(String.self, forKey: .uid)
        title = try container.decode(String.self, forKey: .title)
        address = try container.decode(String.self, forKey: .address)
        location = try container.decode(String.self, forKey: .location)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        photos = try container.decodeIfPresent([URL].self, forKey: .photos) ?? []
        features = try container.decodeIfPresent([String].self, forKey: .features) ?? []
        capacity = try container.decodeIfPresent(Capacity.self, forKey: .capacity) ?? Capacity(standing: 0, theatre: 0, dining: 0, boardroom: 0, uShaped: 0)
        facilities = try container.decodeIfPresent([String].self, forKey: .facilities) ?? []
        pricing = try container.decodeIfPresent(Pricing.self, forKey: .pricing) ?? Pricing(hourly: 0, halfDay: 0, fullDay: 0, multiDay: 0)
        popular = try container.decodeIfPresent(Bool.self, forKey: .popular) ?? false
        reviews = try container.decodeIfPresent([Review].self, forKey: .reviews) ?? []
        rates = try container.decodeIfPresent([Rate].self, forKey: .rates) ?? []
    }
    
    static func == (lhs: Venue, rhs: Venue) -> Bool {
        return lhs.id == rhs.id
    }
}
