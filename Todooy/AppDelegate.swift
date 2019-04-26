//
//  AppDelegate.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    //file:///Users/ryancummins/Library/Developer/CoreSimulator/Devices/777F5C19-57A4-484D-9ADD-A2473816870D/data/Containers/Data/Application/065CF636-D4FA-4008-98BF-2F34BF475206/Documents/

    
    let data = Data()
    data.name = "Kat"
    data.age = 33
    
    do {
      let realm = try Realm()
      try realm.write {
        realm.add(data)
      }
    } catch  {
      print("Error creating new realm, \(error)")
    }
    
    return true
  }



  func applicationWillTerminate(_ application: UIApplication) {
//    print("applicationWillTerminate")
    self.saveContext()
  }

    // MARK: - Core Data stack
  
  
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "DataModel")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

