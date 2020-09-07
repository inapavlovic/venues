//
//  BringNearestVenuesAnnotationView.swift
//  users
//
//  Created by Ina Statkic on 29/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit
import MapKit

class BringNearestVenuesAnnotationView: MKAnnotationView {

    private let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
    
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 22.5
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backgroundMaterial: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 22.5
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .tuna
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(backgroundMaterial)
        backgroundMaterial.contentView.addSubview(imageView)
        backgroundMaterial.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            backgroundMaterial.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundMaterial.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundMaterial.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backgroundMaterial.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant:  2.5)
        ])
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 7).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let annotation = annotation as? LocationAnnotation {
            label.text = annotation.title
            
            if let imageName = annotation.imageName, let image = UIImage(named: imageName) {
                imageView.image = image
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        frame.size = CGSize(width: 175, height: 50)
        centerOffset = CGPoint(x: frame.size.width / 2 - 20.5, y: frame.size.height / 2 - 25)
    }
    
}
