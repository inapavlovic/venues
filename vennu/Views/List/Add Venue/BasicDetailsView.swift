//
//  BasicDetailsView.swift
//  vennu
//
//  Created by Ina Statkic on 10/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class BasicDetailsView: UIView {

    // MARK: Outlets
    
    @IBOutlet private weak var titleTextField: LineTextField!
    @IBOutlet private weak var addressTextField: LineTextField!
    
    // MARK: - Properties
    
    var changeTitle: ((String) -> ())?
    var changeAddress: ((String) -> ())?
    var startTyping: (() -> ())?
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        set()
    }
    
    // MARK: - Data
    
    var title: String? {
        get {
            return titleTextField.text
        }
        set {
            titleTextField.text = newValue
        }
    }
    
    var address: String? {
        get {
            return addressTextField.text
        }
        set {
            addressTextField.text = newValue
        }
    }
    
    // MARK: - Set
    
    private func set() {
        addressTextField.addTarget(self, action: #selector(editingBegin(_:)), for: .editingDidBegin)
        [titleTextField, addressTextField].forEach {
            $0?.isEnabled = true
            $0?.edit = true
            $0?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }
    
    // MARK: - Action
    
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        switch sender {
        case titleTextField: changeTitle?(sender.text ?? "")
        case addressTextField: changeAddress?(sender.text ?? "")
        default: break
        }
    }
    
    @objc private func editingBegin(_ sender: Any) {
        startTyping?()
    }

}
