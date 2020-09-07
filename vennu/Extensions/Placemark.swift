//
//  Placemark.swift
//  vennu
//
//  Created by Ina Statkic on 01/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Contacts
import MapKit

extension MKPlacemark {
    var formattedAddress: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress).replacingOccurrences(of: "\n", with: "")
    }
}
