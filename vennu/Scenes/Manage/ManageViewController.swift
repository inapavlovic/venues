//
//  ManageViewController.swift
//  vennu
//
//  Created by Ina Statkic on 20.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class ManageViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var cateringContainerView: UIView!
    @IBOutlet private weak var feeTextField: UITextField!
    @IBOutlet weak var cateringContainerHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    let child = CateringViewController()
    var fee: Double = 0
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        manageBookingFee()
        set()
    }
    
    // MARK: - Set
    
    private func set() {
        embed(child, into: cateringContainerView)
        feeTextField.layer.cornerRadius = 15
        feeTextField.layer.shadowRadius = 10.0
        feeTextField.layer.shadowOpacity = 0.02
        feeTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        feeTextField.font = .systemFont(ofSize: 14)
        feeTextField.textColor = .coralRed
        feeTextField.addTarget(self, action: #selector(self.textFieldEditingChanged(_:)), for: .editingChanged)
        feeTextField.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
    }
    
    // MARK: - Actions
    
    @objc func editingEnded(_ sender: Any) {
        editBookingFee()
    }
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text?.replacingOccurrences(of: "£", with: "")
        fee = Double("\(text ?? "0")") ?? 0
    }

}

extension ManageViewController {
    private func manageBookingFee() {
        FirebaseManager.shared.fee {
            self.feeTextField.text = "£\(Decimal($0 ?? 0))"
        }
    }
    
    private func editBookingFee() {
        FirebaseManager.shared.fee(value: fee) { error in
            if let error = error {
                self.showError(title: "", message: error.localizedDescription)
            }
        }
    }
}
