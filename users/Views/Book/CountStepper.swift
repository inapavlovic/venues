//
//  CountStepper.swift
//  users
//
//  Created by Ina Statkic on 02/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class CountStepper: UIStepper {
    
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
        tintColor = .coralRed
        setBackgroundImage(UIImage(), for: .normal)
        setDecrementImage(UIImage(named: "step.minus.circle"), for: .normal)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal)
        setIncrementImage(UIImage(named: "step.plus.circle"), for: .normal)
    }

}
