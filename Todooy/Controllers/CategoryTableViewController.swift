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
  var tries = 1
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    manualAddCategory(named: "Step \(tries)")
    
    
  }
  
  func manualAddCategory(named name: String) {
    let newCategory = Category(context: self.context)
    newCategory.name = name
    self.categoryArray.append(newCategory)
    tries += 1
  }
  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = categoryArray[indexPath.row].name
    
    let category = categoryArray[indexPath.row]
    
    return cell
  }
  
  //Mark: - Data Manipulation Methods
  
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category(context: self.context)
      newCategory.name = textField.text!
      self.categoryArray.append(newCategory)
      
      //TODO: - Save Category
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Creates new caegory"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  
  
  //MARK: - Tableview Delegate Methods
  
  
}
