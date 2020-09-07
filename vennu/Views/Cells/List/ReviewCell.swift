//
//  ReviewCell.swift
//  vennu
//
//  Created by Ina Statkic on 19/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class ReviewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        set()
    }
    
    private func set() {
        reviewLabel.attributedText = NSAttributedString(string: reviewLabel.text ?? "", attributes: [NSAttributedString.Key.kern : 0.2])
        reviewLabel.lineSpacing(4)
    }
}

// MARK: - Configure

extension ReviewCell {
    func populate(with review: Review) {
        nameLabel.text = review.author.uppercased()
        reviewLabel.text = review.text
    }
}
