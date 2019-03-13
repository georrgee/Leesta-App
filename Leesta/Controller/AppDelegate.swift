//
//  AppDelegate.swift
//  Leesta
//
//  Created by George Garcia on 3/1/19.
//  Copyright © 2019 George Garcia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataModel = DataModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsTableViewController
        controller.dataModel = dataModel // finds AllListsTableViewController by looking at SB then sets the dataModelProperty
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
        saveData()
    }

    func saveData() {
        dataModel.saveChecklists()
    }
}

