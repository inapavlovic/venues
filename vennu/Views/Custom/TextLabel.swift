//
//  TextLabel.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class BodyLabel: UILabel {
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        textColor = .doveGray
        font = UIFont.systemFont(ofSize: 14)
    }
}
