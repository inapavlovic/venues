//
//  DesertStormTransGradientView.swift
//  users
//
//  Created by Ina Statkic on 28/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class DesertStormTransGradientView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        set()
    }
    
    // MARK: - Set

    func set() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.desertStorm.withAlphaComponent(0).cgColor, UIColor.desertStorm.cgColor]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
