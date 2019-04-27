//
//  ViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
  
  //MARK: - Instance Variables
  
  var todoItems: Results<Item>?
  let realm = try! Realm()
  
  var selectedCategory: Category? {
    didSet{
      loadItems()
    }
  }
  
  //(UIApplication.shared.delegate as! AppDelegate) creates a singleton object of the AppDelegate for the current app
  
  // You could use this to create other plist files
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  //MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // This the location in the file system of the CoreData DB
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
  }
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    cell.textLabel?.text = todoItems?[indexPath.row].title
    
    if let item = todoItems?[indexPath.row] {
    
    cell.textLabel?.text = item.title
    
    //Ternery operator ==>
    // value = condition ? valueIfTure : valueIfFalse
    cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Items Added Yet"
    }
    return cell
    
  }
  
  //MARK: - TableView Delegate Method
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error updating done status")
      }
    }
    
    UIView.animate(withDuration: 0.1, animations: {
      tableView.deselectRow(at: indexPath, animated: true)
    }) {
      (done) in
      self.tableView.reloadData()
    }
  }
  
  //MARK: - Delete Items via swipe
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      if let item = todoItems?[indexPath.row] {
        do {
          try realm.write {
            realm.delete(item)
          }
        } catch {
          print("Error updating done status, \(error)")
        }
      }
      self.tableView.reloadData()
//      context.delete(itemArray[indexPath.row])
//      todoItems.remove(at: indexPath.row)
//      saveItems(andReload: false)
//      tableView.deleteRows(at: [indexPath], with: .fade)
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
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            currentCategory.items.append(newItem)
          }
        } catch {
          print("Error saving new items")
        }
      }
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
  
  
  //MARK: - Model Manipulation Methods
  

  
  func loadItems() {
    
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
    
//    if let additionalPredicate = predicate {
//      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//    } else {
//      request.predicate = categoryPredicate
//    }
//
//
//    do {
//      itemArray = try context.fetch(request)
//    } catch  {
//      print("Error fetching data from context, \(error)")
//    }
//    tableView.reloadData()
  }
  
}

//MARK: - Sarrch Bar Methods
//extension TodoListViewController: UISearchBarDelegate {
//  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//    let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//    request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
//
//    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//    loadItems(with: request, predicate: request.predicate!)
//
//  }
//
//  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    if searchBar.text?.count == 0 {
//      loadItems()
//
//      DispatchQueue.main.async {
//        searchBar.resignFirstResponder()
//      }
//    }
//
//  }
//
//
//}


