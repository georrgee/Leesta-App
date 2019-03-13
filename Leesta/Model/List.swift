//  List.swift
//  Leesta

//  Created by George Garcia on 3/1/19.
//  Copyright © 2019 George Garcia. All rights reserved.

import Foundation

class List: NSObject, NSCoding { // AKA CheckListItem
   
    var text      = ""
    var isChecked = false
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(isChecked, forKey: "Checked")
    }
    
    // takes objects from the NSCoder's decoder object and put their values inside your own properties
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        isChecked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    override init() {
        super.init()
    }
    
    func toggleChecked(){
        isChecked = !isChecked
    }
    
}
