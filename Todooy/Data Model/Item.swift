//
//  Item.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/27/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
