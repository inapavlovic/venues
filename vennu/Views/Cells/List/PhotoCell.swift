//
//  PhotoCell.swift
//  vennu
//
//  Created by Ina Statkic on 20/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoCellDelegate: AnyObject {
    func didRemove(_ indexPath: IndexPath)
}

final class PhotoCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: CardView!
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: PhotoCellDelegate?
    var indexPath: IndexPath!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        set()
    }
    
    // MARK: - Set
    
    private func set() {
        venueImageView.layer.cornerRadius = 15
        removeButton.isHidden = false
    }
    
    // MARK: - Action
    
    @IBAction func removePhoto(_ sender: Any) {
        delegate?.didRemove(indexPath)
    }
    
}

// MARK: - Configuration

extension PhotoCell {
    func populate(with image: UIImage, delegate: PhotoCellDelegate? = nil, indexPath: IndexPath? = nil) {
        venueImageView.image = image
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    func populate(with url: URL) {
        removeButton.isHidden = true
        venueImageView.kf.setImage(with: url, options: [
            .processor(DownsamplingImageProcessor(size: venueImageView.frame.size)),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.4)),
            .cacheOriginalImage
        ])
    }
}
