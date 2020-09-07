//
//  BookFlowController.swift
//  users
//
//  Created by Ina Statkic on 16.12.20..
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class BookFlowController: FlowController {
    
    func showInfo(context: InfoContext) {
        let vc = InfoViewController.instantiate(storyboard: "Book")
        vc.context = context
        currentViewController.present(vc, animated: true)
    }
}
