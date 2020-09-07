//
//  ViewController.swift
//  vennu
//
//  Created by Ina Statkic on 13/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

extension UIViewController {
    typealias Layout = (UIView, UIView) -> ()
    
    func embed<T>(_ vc: T, into parentView: UIView?, layout: Layout = { child, parent in
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: parent.topAnchor),
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    })
        where T: UIViewController {
            
            let container = parentView ?? self.view!
            
            addChild(vc)
            container.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            layout(vc.view, container)
            vc.didMove(toParent: self)
    }
    
    func embed<T>(_ scenes: [T], into container: UIScrollView) where T: UIViewController {
        for (index, scene) in scenes.enumerated() {
            scene.view.frame.origin = CGPoint(x: view.bounds.width * CGFloat(index), y: 0.0)
        }
        scenes.forEach {
            addChild($0)
            $0.view.frame.size = CGSize(width: view.bounds.width, height: view.frame.height)
            container.addSubview($0.view)
            $0.didMove(toParent: self)
        }
        container.contentSize = CGSize(width: CGFloat(scenes.count) * view.bounds.width, height: 0)
    }
}
