//  Checklist.swift
//  Leesta

//  Created by George Garcia on 3/5/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import UIKit

class Checklist: NSObject, NSCoding {
    
    var name = ""
    var items: [List] = []
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    // Loading and Saving Data of Checklist's properties: Name and Items
    required init?(coder aDecoder: NSCoder) {
        name  = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [List]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    func countUncheckItems() -> Int{
        
        var count = 0
        for item in items where !item.isChecked {
            count += 1
        }
        return count
    }
    
}
