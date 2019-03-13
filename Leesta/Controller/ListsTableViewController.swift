//  ListsTableViewController.swift
//  Leesta

//  Created by George Garcia on 3/1/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController, ItemDetailsTableViewControllerDelegate {
    
//    var listOfItems = [List]() // aka items
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    // MARK: TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        let list = checklist.items[indexPath.row]
        
        configureCheckmark(for: cell, with: list)
        configureText(for: cell, with: list)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let list = checklist.items[indexPath.row]
            list.toggleChecked()
            configureCheckmark(for: cell as! ListTableViewCell, with: list)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        //saveCheckListItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        checklist.items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveCheckListItems()
    }
    
    // MARK: Custom Cell Configuration
    
    func configureCheckmark(for cell: ListTableViewCell, with item: List) {
        
        if item.isChecked {
            cell.checkMarkLabel.text = "✓"
        } else {
            cell.checkMarkLabel.text = ""
        }
    }
    
    func configureText(for cell: ListTableViewCell, with item: List) {
        cell.titleLabel.text = item.text
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailsTableViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditItem" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailsTableViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    // MARK: ItemDetailsController Delegate
    func itemDetailsTableViewControllerDidCancel(_ controller: ItemDetailsTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishAdding item: List) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        //saveCheckListItems()
        
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishEditing item: List) {
        
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell as! ListTableViewCell, with: item)
            }
        }
        
        //saveCheckListItems()
        
        dismiss(animated: true, completion: nil)
    }
}
