//
//  BookFlowController.swift
//  vennu
//
//  Created by Ina Statkic on 15/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class BookFlowController: FlowController {
    
    func goToBookingDetails(booking: Booking) {
        let vc = BookingDetailsViewController.instantiate(storyboard: "BookingDetails")
        vc.booking = booking
        currentViewController.show(vc, sender: self)
    }
    
}
