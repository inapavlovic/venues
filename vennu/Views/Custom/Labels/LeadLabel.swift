//
//  LeadLabel.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class LeadLabel: UILabel {
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
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4.0
        attributedText = NSAttributedString(string: text ?? "", attributes: [NSAttributedString.Key.paragraphStyle : style])
        textColor = .tuna
        font = UIFont.systemFont(ofSize: 15)
        textAlignment = .center
    }
}
