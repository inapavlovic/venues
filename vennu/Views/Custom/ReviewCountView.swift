//
//  ShadowRoundView.swift
//  vennu
//
//  Created by Ina Statkic on 23/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class ReviewCountView: UIView {
    
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

    private func set() {
        layer.cornerRadius = frame.size.height / 2
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowRadius = 14.0
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
    }
}
