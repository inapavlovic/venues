//
//  ItemsViewController.swift
//  vennu
//
//  Created by Ina Statkic on 11/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import UIKit

class ItemsViewController<Item, Cell: UITableViewCell>: UITableViewController {
    
    // MARK: Properties
    
    var items: [Item] = []
    let reuseIdentifier = Cell.reuseIdentifier
    var configure: (Item, Cell) -> () = { _, _ in }
    var didSelect: (Item) -> () = { _ in }
    var didSelectAt: (Item, IndexPath) -> () = { _, _ in }
    var didDeselect: (Item) -> () = { _ in }
    var willDisplay: (Cell, IndexPath) -> () = { _, _ in }
    
    // MARK: - Init
    
    init(items: [Item], configure: @escaping (Item, Cell) -> ()) {
        self.configure = configure
        super.init(style: .plain)
        self.items = items
    }
    
    init(configure: @escaping (Item, Cell) -> ()) {
        self.configure = configure
        super.init(style: .plain)
    }
    
    init() {
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
    
        tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        // Uncomment the following line to preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false
        

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        let item = items[indexPath.row]
        configure(item, cell)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didSelect(item)
        didSelectAt(item, indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        didDeselect(item)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay(cell as! Cell, indexPath)
    }

}
