//
//  ListItemsViewController.swift
//  vennu
//
//  Created by Ina Statkic on 18/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

final class NibItemsViewController<Item, Cell: UITableViewCell>: ItemsViewController<Item, Cell> {

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: Cell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}
