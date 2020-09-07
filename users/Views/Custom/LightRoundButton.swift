//
//  LightRoundButton.swift
//  users
//
//  Created by Ina Statkic on 28/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class LightRoundButton: RoundButton {

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
        layer.cornerRadius = bounds.height / 2
        backgroundColor = .desertStorm
    }
}
