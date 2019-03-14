//  Checklist.swift
//  Leesta

//  Created by George Garcia on 3/5/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var items: [List] = []
    var iconName: String
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // Loading and Saving Data of Checklist's properties: Name and Items
    required init?(coder aDecoder: NSCoder) {
        name  = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [List]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
//    func countUncheckItems() -> Int{
//
//        var count = 0
//        for item in items where !item.isChecked {
//            count += 1
//        }
//        return count
//    }
    
    func countUncheckItems() -> Int {
        return items.reduce(0) { count, item in count + (item.isChecked ? 0 : 1) }
        // count = 0
        // after each item, it is incremented by either 0 or 1, depending on if the item was checked or not
    }
}
