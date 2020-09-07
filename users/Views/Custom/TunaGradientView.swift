//
//  BlackWhiteDesertStormGradientView.swift
//  vennu
//
//  Created by Ina Statkic on 20/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class TunaGradientView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        set()
    }
    
    // MARK: - Set

    func set() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.tuna.withAlphaComponent(0.5).cgColor]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
