//
//  RoundTextField.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class RoundTextField: UITextField {
    
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
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25))
    }
    
    private func set() {
        backgroundColor = .white
        borderStyle = .none
        autocorrectionType = .no
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.pumice])
        layer.cornerRadius = frame.height / 2
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.02
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
}
