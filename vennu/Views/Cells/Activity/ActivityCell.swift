//
//  ActivityCell.swift
//  vennu
//
//  Created by Ina Statkic on 23.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit

final class ActivityCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

// MARK: - Configure

extension ActivityCell {
    func populate(with activity: Activity) {
        titleLabel.text = activity.title
        customerLabel.text = "Customer \(activity.customer)"
        timeAgoLabel.text = activity.time.ago()
    }
}
