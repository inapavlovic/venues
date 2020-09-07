//
//  AddCapacityViewController.swift
//  vennu
//
//  Created by Ina Statkic on 12/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

protocol CapacityDelegate: AnyObject {
    func capacity(_ vc: CapacityViewController, _ capacity: [CapacityType])
}

final class CapacityViewController: PresentViewController {
    
    // MARK: Properties
    
    var venueCapacity: Capacity?
    var capacity: [CapacityType] = CapacityType.allCases {
        didSet {
            child.items = capacity
        }
    }
    
    weak var delegate: CapacityDelegate?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CAPACITY"
        setElements()
        setVenueCapacity()
    }
    
    private func setVenueCapacity() {
        if let venueCapacity = venueCapacity {
            let newValue = [
                CapacityType.standing(venueCapacity.standing),
                CapacityType.theatre(venueCapacity.theatre),
                CapacityType.dining(venueCapacity.dining),
                CapacityType.boardroom(venueCapacity.boardroom),
                CapacityType.uShaped(venueCapacity.uShaped)
            ]
            capacity = newValue
        }
    }
    
    // MARK: - Elements
    
    lazy var child = ItemsViewController(items: capacity, configure: { (capacity, cell: ValueInputListCell) in
        cell.textLabel?.text = capacity.name
        cell.detailTextLabel?.text = "up to"
        cell.textField.text = capacity.value > 0 ? "\(capacity.value)" : ""
        cell.textField.tag = capacity.tag
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
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc func save(_ sender: Any) {
        delegate?.capacity(self, capacity)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let formatter = NumberFormatter()
        switch sender.tag {
        case 0:
            let number = formatter.number(from: sender.text!)
            capacity[0] = CapacityType.standing(number?.intValue ?? 0)
        case 1:
            let number = formatter.number(from: sender.text!)
            capacity[1] = CapacityType.theatre(number?.intValue ?? 0)
        case 2:
            let number = formatter.number(from: sender.text!)
            capacity[2] = CapacityType.dining(number?.intValue ?? 0)
        case 3:
            let number = formatter.number(from: sender.text!)
            capacity[3] = CapacityType.boardroom(number?.intValue ?? 0)
        case 4:
            let number = formatter.number(from: sender.text!)
            capacity[4] = CapacityType.uShaped(number?.intValue ?? 0)
        default:
            break
        }
    }
}
