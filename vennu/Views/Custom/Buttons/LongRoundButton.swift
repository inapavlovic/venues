//
//  LongRoundButton.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class LongRoundButton: RoundButton {
    
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
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.85), for: .highlighted)
        backgroundColor = .coralRed
    }
}
