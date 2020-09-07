//
//  PhoneRoundTextField.swift
//  users
//
//  Created by Ina Statkic on 22/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class PhoneRoundTextField: RoundTextField {
    
    // MARK: Properties
    
    let imageView = UIImageView()

    // MARK: - Init
    
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
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 47, bottom: 0, right: 25))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 47, bottom: 0, right: 25))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftViewRect = super.leftViewRect(forBounds: bounds)
        leftViewRect.origin.x = 20
        leftViewRect.size = CGSize(width: 20, height: 20)
        return leftViewRect
    }
    
    private func set() {
        imageView.image = UIImage(named: "phone")
        imageView.tintColor = .spiroDiscoBall
        imageView.frame.size = CGSize(width: 20, height: 20)
        leftView = imageView
        leftViewMode = .always
    }
}
