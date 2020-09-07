//
//  CarrdView.swift
//  vennu
//
//  Created by Ina Statkic on 15/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class CardView: UIView {
    
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
        layer.shadowRadius = 14.0
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.cornerRadius = 15.0
    }
}
