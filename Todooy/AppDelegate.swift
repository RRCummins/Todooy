//
//  AppDelegate.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //Retrieves the app's UserDefaults file path
    
    print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    print("applicationDidEnterBackground")
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    print("applicationWillTerminate")
  }


}

