//
//  AddFeaturesViewController.swift
//  vennu
//
//  Created by Ina Statkic on 12/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

protocol FeaturesDelegate: AnyObject {
    func features(_ vc: FeaturesViewController, _ features: [String])
}

final class FeaturesViewController: PresentViewController {
    
    // MARK: Properties
    
    var features: [FeatureType] = []
    var venueFeatures: [String]?
    
    weak var delegate: FeaturesDelegate?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FEATURES"
        setElements()
        
        child.didSelect = {
            self.features.append($0)
        }
        
        child.didDeselect = { item in
            self.features.removeAll(where: { $0.name == item.name })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let venueFeatures = venueFeatures {
            for feature in venueFeatures {
                FeatureType.allCases.filter { $0.name == feature }.forEach {
                    let indexPath = IndexPath(row: $0.index, section: 0)
                    child.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    features.append($0)
                }
            }
        }
    }
    
    // MARK: - Elements
    
    let child = ItemsViewController(items: FeatureType.allCases, configure: { (feature, cell: CheckListCell) in
        cell.textLabel?.text = feature.name
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
        child.tableView.rowHeight = 54
        child.tableView.allowsMultipleSelection = true
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
        delegate?.features(self, features.map { $0.name })
        dismiss(animated: true, completion: nil)
    }
}
