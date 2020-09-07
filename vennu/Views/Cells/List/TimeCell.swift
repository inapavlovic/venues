//
//  TimeCell.swift
//  vennu
//
//  Created by Ina Statkic on 14.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class TimeCell: UITableViewCell {

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
        imageView?.image = UIImage(named: "watch")?.withTintColor(.tuna)
        textLabel?.font = UIFont.systemFont(ofSize: 12)
        textLabel?.textColor = .doveGray
    }

}
