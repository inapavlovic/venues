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
        
        set()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        set()
    }
    
    // MARK: - Configure
    
    private func set() {
        textColor = .doveGray
        font = UIFont.systemFont(ofSize: 14)
    }
}
