//
//  ViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/8/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
  
  //MARK: - Instance Variables
  
  var todoItems: Results<Item>?
  let realm = try! Realm()
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  var selectedCategory: Category? {
    didSet{
      loadItems()
    }
  }

  
  //MARK: - viewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.separatorStyle = .none
    tableView.rowHeight = 80
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    
    title = selectedCategory?.name
    updateNavBar(withUIColor: theme.themeColor)
    
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    
    updateNavBar(withUIColor: UIColor(hexString: "1D9BF6")!)
    
  }
  
  
  //MARK: - Nav Bar Setup Methods
  func updateNavBar(withUIColor colorName: UIColor) {
    guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
    
    let naveBarColor = colorName
    
    navBar.barTintColor = naveBarColor
    navBar.tintColor = ContrastColorOf(naveBarColor, returnFlat: true)
    searchBar.barTintColor = naveBarColor
    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(naveBarColor, returnFlat: true)]
    
  }
  
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    cell.textLabel?.text = todoItems?[indexPath.row].title
    
    if let item = todoItems?[indexPath.row] {
      
      cell.textLabel?.text = item.title
//      let startingBGColor: UIColor = UIColor(hexString: self.selectedCategory!.backgroundColor)?.lighten(byPercentage: 0.50) ?? FlatWhite()
      let startingBGColor: UIColor = theme.themeColor.lighten(byPercentage: 0.50) ?? FlatWhite()
      if let color = startingBGColor.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
        cell.backgroundColor = color
      }
      cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor ?? FlatWhite(), returnFlat: true)
      
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
            newItem.dateCreated = Date()
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
    
  }
  
  
  override func updateModel(at indexPath: IndexPath) {
    
    if let itemsForDeletion = self.todoItems?[indexPath.row] {
      do {
        try self.realm.write {
          realm.delete(itemsForDeletion)
        }
      } catch {
        print("Error deleting todoList Item, \(error)")
      }
    }
  }
  
}


//MARK: - Sarrch Bar Methods

extension TodoListViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()

  }

  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()

      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }

}


