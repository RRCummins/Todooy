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
  
  var itemArray = [String]()
  //UserDefault
  let defaults = UserDefaults.standard
  
  //MARK - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    itemArray = defaults.array(forKey: "TodoListArray") as! [String]
    
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
  
  //MARK - TableView Delegate Method
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)

  }
  
  //MARK - Add New Item Method
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
      //What happens when the user click the Add Item button on the alert
      self.itemArray.append(textField.text ?? "New item")
      
      //UserDefault
      self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
      self.tableView.reloadData()
      
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Creates new item"
      //This extends the scope of alertTextField
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)

  }
  

}

