//
//  SimpleButton.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class SimpleButton: UIButton {
    
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
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        tintColor = .coralRed
    }
}
