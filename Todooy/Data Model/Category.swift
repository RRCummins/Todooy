//
//  Category.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/27/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var backgroundColor: String = ""
  let items = List<Item>()
}

