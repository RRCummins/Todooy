//
//  CategoryTableViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/23/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
  
  //MARK: - Instance Variables
  
  var categoryArray = [Category]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    manualAddCategory(named: "Step \(tries)")
    
    loadCategory()
    
  }

  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categoryArray[indexPath.row].name
    
    let category = categoryArray[indexPath.row]
    cell.textLabel?.text = category.name
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  
  
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category(context: self.context)
      newCategory.name = textField.text!
      self.categoryArray.append(newCategory)
      
      self.saveCategory(andReload: true)
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
        destinationVC.selectedCategory = categoryArray[indexPath.row]
      }
    }
    
  }
  
  
  
  //Mark: - Data Manipulation Methods
  
  func saveCategory(andReload reload: Bool) {
    do {
      try context.save()
    } catch  {
      print("Error saving context, \(error)")
    }
    
    if reload == true {
      loadCategory()
      self.tableView.reloadData()
    }
    
  }
  
  func loadCategory(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categoryArray = try context.fetch(request)
    } catch  {
      print("Error fetching data from context, \(error)")
    }
    tableView.reloadData()
  }
  
  
}
