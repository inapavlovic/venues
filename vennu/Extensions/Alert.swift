//
//  Alert.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .coralRed
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true)
    }
    
    func alert(title: String, message: String, actions: String..., handler: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .coralRed
        for (index, action) in actions.enumerated() {
            alert.addAction(UIAlertAction.init(title: action, style: .default, handler: { action in
                handler(index)
            }))
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func actionSheet(actions: String..., handler: @escaping (Int) -> Void) {
        let alert = UIAlertController()
        alert.view.tintColor = .coralRed
        
        for (index, action) in actions.enumerated() {
            alert.addAction(UIAlertAction.init(title: action, style: .default, handler: { action in
                handler(index)
            }))
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
