//
//  CategoryTableViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/23/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {
  
  //MARK: - Instance Variables
  
  let realm = try! Realm()
  
  var categories: Results<Category>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
    
  }

  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  //MARK: - Delete Categories via swipe
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      //FIXME: - This only deletes the category not the items in that category
      if let item = categories?[indexPath.row] {
        do {
          try realm.write {
            realm.delete(item)
          }
        } catch {
          print("Error deleting catagory, \(error)")
        }
      }
      self.tableView.reloadData()
    } else if editingStyle == .insert {
      // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table vie
    }
  }

  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category()
      newCategory.name = textField.text!
      
      self.save(category: newCategory)
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Creates new caegory"
      textField = alertTextField
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  
  //MARK: - Tableview Delegate Methods
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "goToItems" {
      let destinationVC = segue.destination as! TodoListViewController
      if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.selectedCategory = categories?[indexPath.row]
      }
    }
    
  }
  
  
  //Mark: - Data Manipulation Methods
  
  func save(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch  {
      print("Error saving context, \(error)")
    }
      loadCategories()
      self.tableView.reloadData()
  }
  
  
  func loadCategories() {
   categories = realm.objects(Category.self)
    tableView.reloadData()
  }
  
  
}
