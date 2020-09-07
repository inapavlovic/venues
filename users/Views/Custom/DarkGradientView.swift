//
//  BlackWhiteDesertStormGradientView.swift
//  vennu
//
//  Created by Ina Statkic on 20/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class DarkGradientView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        set()
    }
    
    // MARK: - Set

    func set() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
