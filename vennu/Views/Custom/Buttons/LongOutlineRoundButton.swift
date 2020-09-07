//
//  LongOutlineRoundButton.swift
//  vennu
//
//  Created by Ina Statkic on 11/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class LongOutlineRoundButton: RoundButton {
    
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

    override func set() {
        super.set()
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        setTitleColor(.coralRed, for: .normal)
        setTitleColor(UIColor.coralRed.withAlphaComponent(0.85), for: .highlighted)
        layer.borderColor = UIColor.coralRed.cgColor
        layer.borderWidth = 1.0
        backgroundColor = .clear
    }
}
