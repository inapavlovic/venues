//
//  FormView.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class FormView: UIView {

    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var businessNameTextField: UITextField!
    @IBOutlet private weak var companyIDTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    
    @IBOutlet private weak var firstDigitTextField: UITextField!
    @IBOutlet private weak var secondDigitTextField: UITextField!
    @IBOutlet private weak var thirdDigitTextField: UITextField!
    @IBOutlet private weak var fourthDigitTextField: UITextField!
    @IBOutlet private weak var fifthDigitTextField: UITextField!
    @IBOutlet private weak var sixthDigitTextField: UITextField!
    
    @IBOutlet private var formTextFields: [UITextField]!
    
    // MARK: - Properties
    
    lazy var auth = Authentication()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clear()
        setupTextFields()
    }
}

// MARK: - Set

extension FormView {
    func setupTextFields() {
        formTextFields.forEach {
            $0.addTarget(self, action: #selector(FormView.textFieldEditingChanged(_:)), for: .editingChanged)
            $0.delegate = self
        }
    }
    
    // MARK: - Action
    
    @objc func textFieldEditingChanged(_ sender: UITextField) {        
        switch sender {
        case nameTextField:
            auth.name = sender.text
        case businessNameTextField:
            auth.businessName = sender.text
        case companyIDTextField:
            auth.companyID = Int(sender.text!)
        case phoneNumberTextField:
            auth.phoneNumber = sender.text
        case addressTextField:
            auth.address = sender.text
        case emailTextField:
            auth.email = sender.text
        case passwordTextField:
            auth.password = sender.text
        case firstDigitTextField:
            auth.firstDigit = sender.text
        case secondDigitTextField:
            auth.secondDigit = sender.text
        case thirdDigitTextField:
            auth.thirdDigit = sender.text
        case fourthDigitTextField:
            auth.forthDigit = sender.text
        case fifthDigitTextField:
            auth.fifthDigit = sender.text
        case sixthDigitTextField:
            auth.sixthDigit = sender.text
        default: break
        }
    }
}

// MARK: - Text Field Delegate

extension FormView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag >= 1 {
            let current = (textField.text ?? "") as NSString
            let new = current.replacingCharacters(in: range, with: string) as NSString
            return new.length <= 1
        } else {
            return true
        }
    }
}

// MARK: - Cleanup

extension FormView {
    func clear() {
        auth.email = nil
        auth.password = nil
        auth.name = nil
        auth.businessName = nil
        auth.companyID = nil
        auth.phoneNumber = nil
        auth.address = nil
    }
}

