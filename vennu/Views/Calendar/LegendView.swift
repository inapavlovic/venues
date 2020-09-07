//
//  LegendView.swift
//  vennu
//
//  Created by Ina Statkic on 12.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class LegendView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private var circleViews: [UIView]!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        set()
    }
    
    // MARK: - Set
    
    private func set() {
        circleViews.forEach {
            $0.layer.cornerRadius = min($0.bounds.height, $0.bounds.width) / 2
        }
    }
    
}
