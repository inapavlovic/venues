//
//  BulletedListViewCell.swift
//  vennu
//
//  Created by Ina Statkic on 11/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class BulletedListCell: UITableViewCell {
    
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
        imageView?.image = UIImage(systemName: "circle.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 10, weight: .unspecified, scale: .medium))?.withTintColor(.coralRed)
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        textLabel?.textColor = .doveGray
    }
}
