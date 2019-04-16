//
//  ViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  //MARK: Instance Variables
  
  var itemArray = [Item]()
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//  //UserDefaults code ↓
//  let defaults = UserDefaults.standard
  
  //MARK: viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    print(dataFilePath)
    
//    let newItem = Item()
//    newItem.title = "Find Mike"
//    newItem.done = false
//    itemArray.append(newItem)

    
    loadItems()
    
  }
  
  //MARK: tableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row].title
    
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    
    //Ternery operator ==>
    // value = condition ? valueIfTure : valueIfFalse
    cell.accessoryType = item.done ? .checkmark : .none
    
    return cell
  }
  
  //MARK: TableView Delegate Method
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    itemArray[indexPath.row].done.toggle()
    saveItems(andReload: false)
    
    UIView.animate(withDuration: 0.1, animations: {
      tableView.deselectRow(at: indexPath, animated: true)
    }) {
      (done) in
      self.tableView.reloadData()
    }

  }
  
  //MARK: Add New Item Method
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
      //What happens when the user click the Add Item button on the alert
      
      let newItem = Item()
      newItem.title = textField.text!
      
      self.itemArray.append(newItem)
      
      self.saveItems(andReload: true)
      
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Creates new item"
      //This extends the scope of alertTextField
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)

  }
  //MARK: Model Manipulation Methods
  
  func saveItems(andReload: Bool) {
    
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("Error encoding item array, \(error)")
    }
    if andReload == true {
      self.tableView.reloadData()
    }
  }
  
  func loadItems() {
    
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      do {
       itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("There was an error decoding data, \(error)")
      }
    }
  }

}


