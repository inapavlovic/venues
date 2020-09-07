//
//  DescriptionView.swift
//  vennu
//
//  Created by Ina Statkic on 17/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class DescriptionView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var descript: ((String) -> ())?
    
    // MARK: - Data
    
    var text: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
    }
}

// MARK: - Text View Delegate

extension DescriptionView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let sizeFit = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: .greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(sizeFit.width, textView.frame.size.width), height: sizeFit.height)

        descript?(textView.text)
        textViewHeight.constant = textView.frame.size.height
    }
}
