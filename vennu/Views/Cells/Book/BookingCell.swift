//
//  BookingCell.swift
//  vennu
//
//  Created by Ina Statkic on 20.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit

final class BookingCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clean()
    }
}

// MARK: - Configure

extension BookingCell {
    func populate(with booking: Booking) {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMM")
        titleLabel.text = booking.title
        dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: booking.startDate!))
        numberOfPeopleLabel.text = "\((booking.catering?.basic)! + (booking.catering?.premium)!) People"
        priceLabel.text = "£ \(Decimal(booking.rentPrice! / 100))"
    }
}

// MARK: - Clear

extension BookingCell {
    private func clean() {
        titleLabel.text = nil
        dateLabel.text = nil
        numberOfPeopleLabel.text = nil
        priceLabel.text = nil
    }
}
