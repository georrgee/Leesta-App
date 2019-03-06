//  ListsTableViewController.swift
//  Leesta

//  Created by George Garcia on 3/1/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

class ListsTableViewController: UITableViewController, ItemDetailsTableViewControllerDelegate {
    
    var listOfItems = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        listOfItems = [List]()
        super.init(coder: aDecoder)
        loadChecklistItems()
    }
    
    // MARK: TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        let list = listOfItems[indexPath.row]
        
        configureCheckmark(for: cell, with: list)
        configureText(for: cell, with: list)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let list = listOfItems[indexPath.row]
            list.toggleChecked()
            configureCheckmark(for: cell as! ListTableViewCell, with: list)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveCheckListItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        listOfItems.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveCheckListItems()
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
                controller.itemToEdit = listOfItems[indexPath.row]
            }
        }
    }
    
    // MARK: ItemDetailsController Delegate
    func itemDetailsTableViewControllerDidCancel(_ controller: ItemDetailsTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishAdding item: List) {
        let newRowIndex = listOfItems.count
        listOfItems.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        saveCheckListItems()
        
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishEditing item: List) {
        
        if let index = listOfItems.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell as! ListTableViewCell, with: item)
            }
        }
        
        saveCheckListItems()
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Document Saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Lists.plist")
    }
    
    func saveCheckListItems() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(listOfItems, forKey: "Lists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems() {
        
        let path = dataFilePath() // put the results in a temporary constant
        if let data = try? Data(contentsOf: path) { // try to load contents of the plist file (List)
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data) // when it does find the List.plist file, load the entire array and its contents from file
            listOfItems = unarchiver.decodeObject(forKey: "Lists") as! [List]
            unarchiver.finishDecoding()
        }
    }
}
