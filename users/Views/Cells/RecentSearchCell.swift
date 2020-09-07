//
//  PhotoTitleCell.swift
//  users
//
//  Created by Ina Statkic on 26/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Kingfisher

final class RecentSearchCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: CardView!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 15
    }
}

// MARK: - Configuration

extension RecentSearchCell {
    func populate(with venue: Venue) {
        label.text = venue.title
        venueImageView.kf.setImage(with: venue.photos.first, options: [
            .processor(DownsamplingImageProcessor(size: venueImageView.frame.size)),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.4)),
            .cacheOriginalImage
        ])
    }
}
