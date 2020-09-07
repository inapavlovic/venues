//
//  SubTitleLabel.swift
//  users
//
//  Created by Ina Statkic on 02/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    
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
        attributedText = NSAttributedString(string: text ?? "", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.kern : 0.92])
    }
}
