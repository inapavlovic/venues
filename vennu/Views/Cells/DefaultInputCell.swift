//
//  DefaultInputViewCell.swift
//  vennu
//
//  Created by Ina Statkic on 14/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class DefaultInputCell: UITableViewCell {
    
    let textField = LineTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 34.0))

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        set()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set
    
    private func set() {
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        textLabel?.textColor = .doveGray
        textField.isEnabled = false
        textField.backgroundColor = .desertStorm
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints([
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: 13)
        ])
    }

}
