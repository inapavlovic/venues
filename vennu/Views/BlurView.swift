//
//  BlurView.swift
//  vennu
//
//  Created by Ina Statkic on 13/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class BlurView: UIView {
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let effect = UIBlurEffect(style: .dark)
        let effectView = IntensityVisualEffectView(effect: effect, intensity: 0.3)
        effectView.frame = self.bounds
        self.addSubview(effectView)
    }

}
