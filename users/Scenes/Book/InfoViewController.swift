//
//  InfoViewController.swift
//  vennu
//
//  Created by Ina Statkic on 15.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

enum InfoContext: String {
    case basic
    case premium
}

final class InfoViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    
    // MARK: - Properties
    
    var context: InfoContext!
    var value: Double? {
        didSet {
            priceLabel.text = "£ \(Decimal(value ?? 0))"
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pricingInfo()
        set()
    }
    
    // MARK: - Set
    
    private func set() {
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.aluminum.cgColor
        containerView.layer.cornerRadius = 20
        textLabel.lineSpacing(5)
        textLabel.textAlignment = .center
        if context == .basic {
            titleLabel.text = "\(InfoContext.basic.rawValue.capitalized) Catering"
        } else if context == .premium {
            titleLabel.text = "\(InfoContext.premium.rawValue.capitalized) Catering"
        }
        blurView.blur(intensity: 0.3)
    }

    // MARK: - Actions
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Web Services

extension InfoViewController {
    private func pricingInfo() {
        FirebaseManager.shared.catering { catering in
            switch self.context {
            case .basic:
                self.textLabel.text = catering.basicInfo
                self.value = catering.basic
            case .premium:
                self.textLabel.text = catering.premiumInfo
                self.value = catering.premium
            case .none: ()
            }
        }
    }
}
