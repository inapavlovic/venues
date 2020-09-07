//
//  PopularVenueCell.swift
//  users
//
//  Created by Ina Statkic on 26/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Kingfisher

final class PopularVenueCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: CardView!
    @IBOutlet weak var overlayView: TunaGradientView!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        set()
    }
    
    // MARK: - Set UI
    
    private func set() {
        [overlayView, venueImageView].forEach {
            $0?.layer.cornerRadius = 15
        }
    }
}

// MARK: - Configuration

extension PopularVenueCell {
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
