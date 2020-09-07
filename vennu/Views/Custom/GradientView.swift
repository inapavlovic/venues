//
//  DesertStormGradientView.swift
//  vennu
//
//  Created by Ina Statkic on 20/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class DesertStormGradientView: UIView {

    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        set()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        set()
    }
    
    // MARK: - Set

    func set() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.desertStorm.cgColor, UIColor.desertStormClear.cgColor, UIColor.desertStormClear.cgColor]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
