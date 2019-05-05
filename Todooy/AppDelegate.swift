//
//  AppDelegate.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    do {
      _ = try Realm()
    } catch  {
      print("Error creating new realm, \(error)")
    }
    return true
  }

  
}
