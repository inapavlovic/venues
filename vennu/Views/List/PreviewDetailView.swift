//
//  PreviewDetailView.swift
//  vennu
//
//  Created by Ina Statkic on 13/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class PreviewDetailView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var availabilityButton: UIButton!
    
    // MARK: Properties
    
    var availability: (() -> ())?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        set()
    }
    
    // MARK: - Data
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var address: String? {
        get {
            return addressLabel.text
        }
        set {
            addressLabel.text = newValue
        }
    }
    
    var price: Decimal? {
        get {
            return NumberFormatter.decimalFormatter.number(from: priceLabel.text!)?.decimalValue
        }
        set {
            priceLabel.text = "£ \(newValue!)"
        }
    }
    
    // MARK: - Set
    
    private func set() {
        availabilityButton.addTarget(self, action: #selector(openCalendar(_:)), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    private func openCalendar(_ sender: Any) {
        availability?()
    }

}
