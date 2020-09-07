//
//  AddPricingViewController.swift
//  vennu
//
//  Created by Ina Statkic on 12/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

protocol PricingDelegate: AnyObject {
    func pricing(_ vc: PricingViewController, _ pricing: [PricingType])
}

final class PricingViewController: PresentViewController {
    
    // MARK: Properties
    
    var venuePricing: Pricing?
    var pricing: [PricingType] = PricingType.allCases {
        didSet {
            child.items = pricing
        }
    }
    
    weak var delegate: PricingDelegate?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PRICING"
        setElements()
        setVenuePricing()
    }
    
    private func setVenuePricing() {
        if let venuePricing = venuePricing {
            let newValue = [
                PricingType.hourly(venuePricing.hourly),
                PricingType.halfDay(venuePricing.halfDay),
                PricingType.fullDay(venuePricing.fullDay),
                PricingType.multiDay(venuePricing.multiDay)
            ]
            pricing = newValue
        }
    }
    
    // MARK: - Elements
    
    lazy var child = ItemsViewController(items: pricing, configure: { (price, cell: ValueInputListCell) in
        cell.textLabel?.text = price.name
        cell.detailTextLabel?.text = "£ "
        cell.textField.text = price.value > 0 ? "\(Decimal(price.value))" : ""
        cell.textField.tag = price.tag
        cell.textField.addTarget(self, action: #selector(self.textFieldEditingChanged(_:)), for: .editingChanged)
    })
    
    private lazy var saveButton: LongRoundButton = {
        let button = LongRoundButton(frame: CGRect(
            x: view.directionalLayoutMargins.leading,
            y: view.frame.height - 136,
            width: view.frame.width - (view.directionalLayoutMargins.leading + view.directionalLayoutMargins.trailing),
            height: 50.0
        ))
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setElements() {
        embed(child, into: view)
        child.tableView.rowHeight = 46
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact ? 200 : 0),
            view.layoutMarginsGuide.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .compact ? 200 : 0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16)
        ])
    }
    
    // MARK: - Actions
    
    @objc func save(_ sender: Any) {
        delegate?.pricing(self, pricing)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        switch sender.tag {
        case 0:
            let number = formatter.number(from: sender.text!)
            pricing[0] = PricingType.hourly(number?.doubleValue ?? 0)
        case 1:
            let number = formatter.number(from: sender.text!)
            pricing[1] = PricingType.halfDay(number?.doubleValue ?? 0)
        case 2:
            let number = formatter.number(from: sender.text!)
            pricing[2] = PricingType.fullDay(number?.doubleValue ?? 0)
        case 3:
            let number = formatter.number(from: sender.text!)
            pricing[3] = PricingType.multiDay(number?.doubleValue ?? 0)
        default:
            break
        }
    }
}
