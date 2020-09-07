//
//  SegmentedControl.swift
//  vennu
//
//  Created by Ina Statkic on 14/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit.UISegmentedControl

extension UISegmentedControl {
    func setLineForSegment() {
        let line = UIView()
        let lineWidth: CGFloat = bounds.size.width / CGFloat(numberOfSegments)
        line.frame = CGRect(x: CGFloat(selectedSegmentIndex) * lineWidth, y: bounds.size.height - 1.0, width: lineWidth, height: 1.0)
        line.backgroundColor = .coralRed
        line.tag = 1
        addSubview(line)
    }
    
    func updateLineFrame() {
        guard let line = viewWithTag(1) else { return }
        let lineWidth: CGFloat = bounds.size.width / CGFloat(numberOfSegments)
        line.frame = CGRect(x: CGFloat(selectedSegmentIndex) * lineWidth, y: bounds.size.height - 1.0, width: lineWidth, height: 1.0)
    }
    
    func animateLineForSegment() {
        guard let line = viewWithTag(1) else { return }
        UIView.animate(withDuration: 0.3) {
            line.frame.origin.x = self.bounds.width / CGFloat(self.numberOfSegments) * CGFloat(self.selectedSegmentIndex)
        }
    }
}
