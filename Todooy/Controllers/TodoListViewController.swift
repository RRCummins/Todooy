//
//  ViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
  
  //MARK: - Instance Variables
  
  var itemArray = [Item]()
  
  //(UIApplication.shared.delegate as! AppDelegate) creates a singleton object of the AppDelegate for the current app
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  // You could use this to create other plist files
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  //MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // This the location in the file system of the CoreData DB
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    loadItems()
    
  }
  
  //MARK: - TableView Datasource Methods
  
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
  
  //MARK: - TableView Delegate Method
  
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
  
  //MARK: - Delete Rows via swipe
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      context.delete(itemArray[indexPath.row])
      itemArray.remove(at: indexPath.row)
      saveItems(andReload: false)
      tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
  }
  
  
  //MARK: - Add New Item Method
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
      //What happens when the user click the Add Item button on the alert
      
      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      newItem.done = false
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
  
  
  //MARK: - Model Manipulation Methods
  
  func saveItems(andReload: Bool) {
    
    do {
      try context.save()
    } catch {
      print("Error saving context, \(error)")
    }
    if andReload == true {
      loadItems()
      self.tableView.reloadData()
    }
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

    do {
      itemArray = try context.fetch(request)
    } catch  {
      print("Error fetching data from context, \(error)")
    }
  }
  
}

//MARK: - Sarrch Bar Methods
extension TodoListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")

    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request)
    
  }
  
  
  
}


