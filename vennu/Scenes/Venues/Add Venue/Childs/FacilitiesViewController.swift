//
//  AddFacilitiesViewController.swift
//  vennu
//
//  Created by Ina Statkic on 12/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

protocol FacilitiesDelegate: AnyObject {
    func facilities(_ vc: FacilitiesViewController, _ facilities: [Facility])
}

final class FacilitiesViewController: PresentViewController {
    
    // MARK: Properties
    
    var facilities: [FacilityType] = []
    var venueFacilities: [String]?
    
    weak var delegate: FacilitiesDelegate?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FACILITIES"
        setNavigation()
        setElements()
        
        child.didSelect = {
            self.facilities.append($0)
        }

        child.didDeselect = { item in
            self.facilities.removeAll(where: { $0.name == item.name })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let venueFacilities = venueFacilities {
            for facility in venueFacilities {
                FacilityType.allCases.filter { $0.name == facility }.forEach {
                    let indexPath = IndexPath(row: $0.index, section: 0)
                    child.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    facilities.append($0)
                }
            }
        }
        
    }
    
    // MARK: - Elements
    
    let child = ItemsViewController(items: FacilityType.allCases, configure: { (facility, cell: CheckListCell) in
        cell.textLabel?.text = facility.name
        cell.imageView?.image = facility.image
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
        self.addChild(child)
        view.addSubview(child.view)
        child.view.frame.size = CGSize(width: view.bounds.width, height: view.bounds.height - 136)
        child.didMove(toParent: self)
        child.tableView.rowHeight = 54
        child.tableView.allowsMultipleSelection = true
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular ? 0 : 200),
            view.layoutMarginsGuide.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular ? 0 : 200),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc func save(_ sender: Any) {
        var f = [Facility]()
        for item in facilities {
            FacilityType.allCases.filter { $0 == item }.forEach {
                f.append(Facility(image: $0.image, name: $0.name))
            }
        }
        delegate?.facilities(self, f)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Navigation

extension FacilitiesViewController {
    private func setNavigation() {
        navigationController?.navigationBar.backgroundColor = .white
    }
}
