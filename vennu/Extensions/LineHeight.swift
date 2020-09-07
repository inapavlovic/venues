//
//  LineHeight.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit.UILabel

extension UILabel {
    func lineSpacing(_ value: CGFloat) {
        let text = self.text
        if let text = text {
            let attributedString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = value
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            attributedText = attributedString
        }
    }
}
