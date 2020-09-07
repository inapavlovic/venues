//
//  LineTextField.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class LineTextField: UITextField {
    
    var edit: Bool = false {
        didSet {
            if isEnabled {
                underline()
            } else {
                clearUnderline()
            }
        }
    }
    
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
        borderStyle = .none
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.doveGray])
        font = UIFont.systemFont(ofSize: 14)
        textColor = .doveGray
    }
}

extension LineTextField {
    func underline() {
        layer.backgroundColor = UIColor.desertStorm.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.aluminum.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
    func clearUnderline() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.clear.cgColor
    }
}
