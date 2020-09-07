//
//  LoadStoryboard.swift
//  vennu
//
//  Created by Ina Statkic on 05/10/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

public protocol LoadStoryboard {
    static var name: String { get }
    static var identifier: String { get }
}

extension LoadStoryboard where Self: UIViewController {
    
    public static var name: String {
        return String(describing: self)
    }
    
    public static var identifier: String {
        return String(describing: self)
    }
    
    /// Instantiate View Controller with the same name as Storyboard ID
    public static func instantiate(storyboard name: String? = nil) -> Self {
        let storyboard = UIStoryboard(name: name ?? self.name, bundle: nil)
        return  instantiate(from: storyboard)
    }
    
    static func instantiate(from storyboard: UIStoryboard) -> Self {
        guard let vc = storyboard.instantiateViewController(withIdentifier: self.identifier) as? Self else {
            fatalError()
        }
        return vc
    }
}

extension UIViewController: LoadStoryboard { }

