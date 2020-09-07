//
//  PaymentCardControl.swift
//  users
//
//  Created by Ina Statkic on 07/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class PaymentCardControl: UIControl {
    
    // MARK: Outlets
    
    @IBOutlet private weak var fundingLabel: UILabel!
    @IBOutlet private weak var addCardLabel: UILabel!
    @IBOutlet private weak var last4DigitsLabel: UILabel!
    
    // MARK: - Data model
    
    var last4: String = "" {
        didSet {
            last4DigitsLabel.isHidden = last4.isEmpty
            last4DigitsLabel.attributedText = NSAttributedString(string: "**** \(last4)", attributes: [.font : UIFont.boldSystemFont(ofSize: 18), .kern : 1.38])
            backgroundColor = last4.isEmpty ? .clear : .coralRed
            addCardLabel.isHidden = !last4.isEmpty
            
        }
    }
    
    var funding: String {
        get {
            fundingLabel.text ?? ""
        }
        set {
            fundingLabel.attributedText = NSAttributedString(string: "\(newValue.uppercased()) CARD", attributes: [.font : UIFont.boldSystemFont(ofSize: 12), .kern : 0.92])
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        set()
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    // MARK: - Set

    private func set() {
        layer.cornerRadius = 9.0
        backgroundColor = .clear
        clipsToBounds = true
        layer.borderColor = UIColor.coralRed.cgColor
        layer.borderWidth = 1
    }

}
