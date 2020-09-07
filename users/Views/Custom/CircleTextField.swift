//
//  CircleTextField.swift
//  users
//
//  Created by Ina Statkic on 22/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class CircleTextField: RoundTextField {
    
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
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private func set() {
        textAlignment = .center
   }
}
