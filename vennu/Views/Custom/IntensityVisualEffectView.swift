//
//  IntensityVisualEffectView.swift
//  vennu
//
//  Created by Ina Statkic on 13/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class IntensityVisualEffectView: UIVisualEffectView {
    
    private var animator: UIViewPropertyAnimator!

    init(effect: UIVisualEffect?, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            [unowned self] in self.effect = effect
        }
        animator.fractionComplete = intensity
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
