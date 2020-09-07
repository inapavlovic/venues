//
//  PhotoCollectionViewCell.swift
//  vennu
//
//  Created by Ina Statkic on 15/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class PhotoCell: UICollectionViewCell, ReusableView {
    
    
    // MARK: - Configuration
    
    func populate(with image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 15
        self.addSubview(imageView)
    }
}
