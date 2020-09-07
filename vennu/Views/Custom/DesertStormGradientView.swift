//
//  DesertStormGradientView.swift
//  vennu
//
//  Created by Ina Statkic on 20/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class DesertStormGradientView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        set()
    }
    
    // MARK: - Set

    func set() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.desertStorm.cgColor, UIColor.desertStorm.withAlphaComponent(0.6).cgColor, UIColor.desertStorm.withAlphaComponent(0).cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
}
