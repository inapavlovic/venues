//
//  MapListCell.swift
//  users
//
//  Created by Ina Statkic on 29/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Kingfisher

final class MapListCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    
    // MARK: - Properties
    
    var rating: Double = 0
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        clean()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clean()
    }
}

// MARK: - Configuration

extension MapListCell {
    func populate(with venue: Venue) {
        if let image = venue.photos.first {
            photoView.kf.setImage(with: image, options: [
                .processor(DownsamplingImageProcessor(size: photoView.frame.size)),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.4)),
                .cacheOriginalImage
            ])
        }
        titleLabel.text = venue.title
        addressLabel.text = venue.address.street()
        priceLabel.text = "£ \(Decimal(venue.pricing.hourly))"
        if venue.rates.count > 0 {
            rating = venue.rates.map { Double($0.stars) }.reduce(0, +) / Double(venue.rates.count)
        }
        reviewsLabel.text = "\(rating) / \(venue.reviews.count) reviews"
    }
}

// MARK: - Clear

extension MapListCell {
    private func clean() {
        titleLabel.text = nil
        addressLabel.text = nil
        priceLabel.text = nil
        photoView.image = nil
        reviewsLabel.text = nil
    }
}
