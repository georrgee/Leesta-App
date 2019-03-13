//  CheckListDetailTableViewController.swift
//  Leesta
//
//  Created by George Garcia on 3/8/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

protocol CheckListDetailViewControllerDelegate: class {
    
    func checklistDetailViewControllerDidCancel(_ controller: CheckListDetailTableViewController)
    func checklistDetailViewController(_ controller: CheckListDetailTableViewController, didFinishAdding checklist: Checklist)
    func checklistDetailViewController(_ controller: CheckListDetailTableViewController, didFinishEditing checklist: Checklist)
}

class CheckListDetailTableViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBAction func cancelButtonTapped() {
        delegate?.checklistDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneButtonTapped(){
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.checklistDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            delegate?.checklistDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    weak var delegate: CheckListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
        
    }
    
    func setupNavTitle() {
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
}
