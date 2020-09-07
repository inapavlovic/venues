//
//  MinimalTextView.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MinimalTextView: IQTextView {
    // MARK: Init
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        set()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        set()
    }
    
    // MARK: - Configure
    
    private func set() {
        backgroundColor = .clear
        textContainerInset = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: -5.0)
        contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4.0
        attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : style])
        font = UIFont.systemFont(ofSize: 14)
    }
}
