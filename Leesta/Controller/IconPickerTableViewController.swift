//
//  IconPickerTableViewController.swift
//  Leesta
//
//  Created by George Garcia on 3/13/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

protocol IconPickerDelegate: class {
    func iconPicker(_ picker: IconPickerTableViewController, didPick iconName: String)
}

class IconPickerTableViewController: UITableViewController {
    
    weak var delegate: IconPickerDelegate?
    let icons = ["No Icon", "Appointments", "Birthdays",
                 "Chores", "Drinks", "Folder", "Groceries",
                 "Inbox", "Photos", "Trips"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
    
}
