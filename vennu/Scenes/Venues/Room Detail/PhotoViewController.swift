//
//  PhotoViewController.swift
//  vennu
//
//  Created by Ina Statkic on 14.1.21..
//  Copyright © 2021 Ina. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotoViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var photoView: UIImageView!
    
    // MARK: - Properties
    
    var image: URL!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
    }
    
    // MARK: - Set
    
    private func set() {
        photoView.kf.setImage(with: image)
    }
    
    // MARK: - Actions
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }

}
