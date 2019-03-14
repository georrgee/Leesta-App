//
//  DataModel.swift
//  Leesta
//
//  Created by George Garcia on 3/12/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int { //computed property
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTimers()
    }
    
    func registerDefaults() {
        let dictionary: [String : Any] = ["ChecklistIndex" : -1, "FirstTime" : true]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTimers(){
        
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    // MARK: Sorting Checklists
    
    func printDocumentDirectoryAndFilePath(){
        print("Documents Folder is \(documentsDirectory())")
        print("Data File Path is \(dataFilePath())")
    }
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
    
    // MARK: Document Saving
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        
        let path = dataFilePath() // put the results in a temporary constant
        if let data = try? Data(contentsOf: path) { // try to load contents of the plist file (List)
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data) // when it does find the List.plist file, load the entire array and its contents from file
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }
}
