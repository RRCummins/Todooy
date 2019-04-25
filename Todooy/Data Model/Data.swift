//
//  Data.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/24/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
  
  @objc dynamic var name: String = ""
  @objc dynamic var age: Int = 0
  
}
