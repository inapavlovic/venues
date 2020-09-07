//
//  AddPhotoCell.swift
//  vennu
//
//  Created by Ina Statkic on 24/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

protocol AddPhotoDelegate: AnyObject {
    func addPhoto()
}

final class AddPhotoCell: UICollectionViewCell {
    
    weak var delegate: AddPhotoDelegate?
    
    // MARK: - Action
    
    @IBAction func addPhoto(_ sender: Any) {
        delegate?.addPhoto()
    }
}
