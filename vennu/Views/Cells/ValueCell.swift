//
//  ValueListViewCell.swift
//  vennu
//
//  Created by Ina Statkic on 11/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class ValueCell: UITableViewCell {

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
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
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.textColor = .doveGray
    }
}
