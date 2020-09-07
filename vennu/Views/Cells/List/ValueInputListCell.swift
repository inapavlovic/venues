//
//  ValueInputListViewCell.swift
//  vennu
//
//  Created by Ina Statkic on 11/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class ValueInputListCell: UITableViewCell {
    
    let textField = LineTextField(frame: CGRect(x: 0, y: 0, width: 36, height: 34.0))

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textField.backgroundColor = .white
        set()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func set() {
        tintColor = .coralRed
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        textLabel?.textColor = .doveGray
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.textColor = .doveGray
        textField.keyboardType = .numberPad
        textField.isEnabled = true
        textField.edit = true
        self.accessoryView = textField
        self.accessoryView?.backgroundColor = .white
    }
}
