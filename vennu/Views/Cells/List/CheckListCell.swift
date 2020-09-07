//
//  CheckListViewCell.swift
//  vennu
//
//  Created by Ina Statkic on 11/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class CheckListCell: UITableViewCell {

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        set()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let checkmark = UIImageView(image: !selected ? UIImage(named: "circle") : UIImage(named: "check.circle"))
        checkmark.frame.size = CGSize(width: 24.0, height: 24.0)
        self.accessoryView = checkmark
    }
    
    private func set() {
        tintColor = .coralRed
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        textLabel?.textColor = .doveGray
        underline()
    }
    
    private func underline() {
        let line = CALayer()
        line.borderWidth = 1.0
        line.borderColor = UIColor.iron.cgColor
        line.frame = CGRect(
            x: layoutMargins.left + 8,
            y: frame.size.height + 4,
            width: UIScreen.main.bounds.size.width - ((layoutMargins.right + 8) + (layoutMargins.left + 8)),
            height: 1.0)
        layer.addSublayer(line)
    }
}
