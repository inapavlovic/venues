//
//  BookingCollectionCell.swift
//  users
//
//  Created by Ina Statkic on 20.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit

final class BookingCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var starsImageViews: [UIImageView]!
    
    // MARK: - Properties
    
    var rating = 0 {
        didSet {
            for (index, star) in starsImageViews.enumerated() {
                star.isHighlighted = index < rating
            }
        }
    }

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

extension BookingCell {
    func populate(with venue: Venue) {
        if let image = venue.photos.first {
            photoView.kf.setImage(with: image)
        }
        titleLabel.text = venue.title
        addressLabel.text = venue.address
        if venue.rates.count > 0 {
            rating = venue.rates.map { $0.stars }.reduce(0, +) / venue.rates.count
        }
    }
}

// MARK: - Clear

extension BookingCell {
    private func clean() {
        titleLabel.text = nil
        addressLabel.text = nil
        photoView.image = nil
    }
}
