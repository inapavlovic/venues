//
//  BookingDetailsPriceView.swift
//  vennu
//
//  Created by Ina Statkic on 15/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class BookingDetailsPriceView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var rentPriceLabel: UILabel!
    @IBOutlet private weak var cateringPriceLabel: UILabel!
    @IBOutlet private weak var bookingFeeLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Data
    
    var rentPrice: Decimal? {
        get {
            return NumberFormatter.decimalFormatter.number(from: rentPriceLabel.text!)?.decimalValue
        }
        set {
            rentPriceLabel.text = "£\(newValue!)"
        }
    }
    
    var cateringPrice: Decimal? {
        get {
            return NumberFormatter.decimalFormatter.number(from: cateringPriceLabel.text!)?.decimalValue
        }
        set {
            cateringPriceLabel.text = "£\(newValue ?? 0)"
        }
    }
    
    var fee: Decimal? {
        get {
            return NumberFormatter.decimalFormatter.number(from: bookingFeeLabel.text!)?.decimalValue
        }
        set {
            bookingFeeLabel.text = "£\(newValue ?? 0)"
            
        }
    }
    
    var totalPrice: Decimal? {
        get {
            return NumberFormatter.decimalFormatter.number(from: totalPriceLabel.text!)?.decimalValue
        }
        set {
            totalPriceLabel.text = "£ \(newValue!)"
        }
    }


}
