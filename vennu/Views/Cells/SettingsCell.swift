//
//  SettingsViewCell.swift
//  vennu
//
//  Created by Ina Statkic on 14/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        tintColor = .coralRed
        set()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        
        textLabel?.textColor = highlighted ? .coralRed : .tuna
    }
    
    // MARK: - Set
    
    private func set() {
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = .tuna
        underline()
    }
    
    private func underline() {
        let line = CALayer()
        line.borderWidth = 1.0
        line.borderColor = UIColor.santasGray.cgColor
        line.frame = CGRect(
            x: layoutMargins.left + 8,
            y: frame.size.height + 4,
            width: UIScreen.main.bounds.size.width - ((layoutMargins.right + 8) + (layoutMargins.left + 8)),
            height: 1.0)
        layer.addSublayer(line)
    }

}
