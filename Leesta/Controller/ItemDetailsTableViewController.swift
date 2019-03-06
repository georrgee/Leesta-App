//
//  ItemDetailsTableViewController.swift
//  Leesta
//
//  Created by George Garcia on 3/1/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import UIKit

protocol ItemDetailsTableViewControllerDelegate: class {
    func itemDetailsTableViewControllerDidCancel(_ controller: ItemDetailsTableViewController)
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishAdding item: List)
    func itemDetailsTableViewController(_ controller: ItemDetailsTableViewController, didFinishEditing item: List)
}

class ItemDetailsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailsTableViewControllerDelegate?
    var itemToEdit: List?
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.itemDetailsTableViewControllerDidCancel(self)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if let item = itemToEdit {
            item.text = itemTextField.text!

            delegate?.itemDetailsTableViewController(self, didFinishEditing: item)
        } else {
            let item = List()
            
            item.text = itemTextField.text!
            item.isChecked = false

            delegate?.itemDetailsTableViewController(self, didFinishAdding: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavForEditItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemTextField.becomeFirstResponder()
    }
    
    // It is invoked every time the user changes the text, whether by tapping on the keyboard or by cut/paste.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneButton.isEnabled = (newText.length > 0)
        
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil      // disables the gray selection when tapped cell
    }
    
    // MARK: Edit Item
    
    func setupNavForEditItem(){
        guard let item = itemToEdit else { return }
        title = "Edit Item"
        itemTextField.text = item.text
    }
}
