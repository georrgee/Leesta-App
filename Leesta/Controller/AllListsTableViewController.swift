//
//  AllListsTableViewController.swift
//  Leesta
//
//  Created by George Garcia on 3/5/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController, CheckListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
//    var lists: [Checklist]
    
//    required init?(coder aDecoder: NSCoder) {
//        lists = [Checklist]()
//        super.init(coder: aDecoder)
//        loadChecklists()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        print("Documents Folder is \(documentsDirectory())")
//        print("Data File Path is \(dataFilePath())")
    }
    
    override func viewDidAppear(_ animated: Bool) { // check at startup which checklist you need to show and then perform segue manually
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "showChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        
        let count = checklist.countUncheckItems()
        
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "No Items"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All done!"
        } else {
            cell.detailTextLabel!.text = "\(checklist.countUncheckItems()) remaining"

        }
        
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showChecklist" {
            
            let controller = segue.destination as! ListsTableViewController
            controller.checklist = sender as! Checklist
            
        } else if segue.identifier == "addChecklist" {
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! CheckListDetailTableViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       dataModel.indexOfSelectedChecklist = indexPath.row // storing the selected row into UserDefaults
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "showChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "CheckListDetailTableViewController") as! UINavigationController
        
        let controller = navigationController.topViewController as! CheckListDetailTableViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func checklistDetailViewControllerDidCancel(_ controller: CheckListDetailTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func checklistDetailViewController(_ controller: CheckListDetailTableViewController, didFinishAdding checklist: Checklist) {
        
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func checklistDetailViewController(_ controller: CheckListDetailTableViewController, didFinishEditing checklist: Checklist) {
        
        if let index = dataModel.lists.index(of: checklist) {
            
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = checklist.name
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    // method gets called whenever the nav controller will go to a new screen
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1 // no checklist is currently selected
        }
    }
}
