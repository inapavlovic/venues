//
//  View.swift
//  vennu
//
//  Created by Ina Statkic on 02/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

extension UIView {
    func blur(intensity: CGFloat) {
        let effect = UIBlurEffect(style: .dark)
        let effectView = IntensityVisualEffectView(effect: effect, intensity: intensity)
        effectView.frame = bounds
        addSubview(effectView)
    }
}
