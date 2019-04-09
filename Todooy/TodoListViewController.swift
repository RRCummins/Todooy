//
//  ViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  //MARK - Instance Variables
  
  let itemArray = ["Find Mike", "Buy Eggod", "Destroy Demogorgon"]
  
  //MARK - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //MARK - tableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    return cell
  }
  

}

