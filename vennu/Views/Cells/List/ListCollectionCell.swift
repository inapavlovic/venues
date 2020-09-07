//
//  ListCollectionCell.swift
//  vennu
//
//  Created by Ina Statkic on 9.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit
import Kingfisher

final class ListCollectionCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet var starsImageViews: [UIImageView]!
    
    // MARK: - Properties
    
    var rating: Double = 0 {
        didSet {
            for (index, star) in starsImageViews.enumerated() {
                star.isHighlighted = index < Int(rating)
                star.highlightedImage = UIImage(systemName: star.isHighlighted ? "star.fill" : "star")
            }
        }
    }
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        clean()
        set()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clean()
    }
    
    // MARK: - Set
    
    private func set() {
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowRadius = 14.0
        containerView.layer.shadowOpacity = 0.06
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        containerView.layer.cornerRadius = 15
        starsImageViews.forEach {
            $0.highlightedImage = UIImage(systemName: $0.isHighlighted ? "star.fill" : "star")
        }
    }

}

// MARK: - Configuration

extension ListCollectionCell {
    func populate(with venue: Venue) {
        if let image = venue.photos.first {
            photoView.kf.setImage(with: image)
        }
        titleLabel.text = venue.title
        addressLabel.text = venue.address
        priceLabel.text = "£ \(Decimal(venue.pricing.hourly))"
        if venue.rates.count > 0 {
            rating = venue.rates.map { Double($0.stars) }.reduce(0, +) / Double(venue.rates.count)
        }
        reviewsLabel.text = "\(rating) / \(venue.reviews.count) reviews"
    }
}

// MARK: - Clear

extension ListCollectionCell {
    private func clean() {
        titleLabel.text = nil
        addressLabel.text = nil
        priceLabel.text = nil
        photoView.image = nil
        reviewsLabel.text = nil
    }
}
