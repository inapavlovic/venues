//
//  CurrentLocationAnnotation.swift
//  users
//
//  Created by Ina Statkic on 29/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String? = "BRING NEAREST VENUES"
    
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
