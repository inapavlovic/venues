//
//  PickPhotoButton.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class PickPhotoButton: UIButton {
    
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
        layer.shadowRadius = 14.0
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.cornerRadius = 15
        backgroundColor = .iron
        tintColor = .white
        setImage(UIImage(systemName: "plus")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .large)), for: .normal)
    }
}
