//
//  CategoryTableViewController.swift
//  Todooy
//
//  Created by Ryan Cummins on 4/23/19.
//  Copyright © 2019 Them Rhinos. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
  
  
  //MARK: - Instance Variables
  
  let realm = try! Realm()
  
  var categories: Results<Category>?
  
  @IBOutlet weak var barThemeButton: UIBarButtonItem!
  
  var themeBaseColors: Array = [FlatLime(), FlatOrange(), FlatMint(), FlatMagenta(), FlatTeal(), FlatPurple(), FlatPowderBlue()]
  
  
  //MARK: - View Change Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadCategories()
    tableView.rowHeight = 80
    tableView.separatorStyle = .none
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    
//    title = selectedCategory?.name
    updateNavBar(withUIColor: theme.themeColor)
    tableView.backgroundColor = theme.themeColor.darken(byPercentage: 0.5)
    
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
    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(naveBarColor, returnFlat: true)]
    
  }

  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories?.count ?? 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    
//    if let category = categories?[indexPath.row] {
//      guard let categoryColor = UIColor(hexString: category.backgroundColor) else {fatalError()}
      let startingBGColor: UIColor = theme.themeColor.lighten(byPercentage: 0.50) ?? FlatWhite()
      if let cellColor = startingBGColor.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(categories!.count)) {
        cell.backgroundColor = cellColor
        //FIXME: - SelectionStyle needs to be a 10% darker version of the cell not none
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
      }
//      cell.backgroundColor = categoryColor
//      cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
//    }
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
      let newCategory = Category()
      
      newCategory.name = textField.text!
      newCategory.backgroundColor = UIColor.randomFlat.hexValue()

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
  
  // Delete Method
  
  override func updateModel(at indexPath: IndexPath) {
    
    if let categoryForDeletion = self.categories?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(categoryForDeletion)
        }
      } catch {
        print("Error deleting item, \(error)")
      }
    }
    
  }
  
  @IBAction func barThemeButtonPressed(_ sender: Any) {
    
    theme.themeColor = themeBaseColors[Int.random(in: 0..<themeBaseColors.count)]
    tableView.reloadData()
    updateNavBar(withUIColor: theme.themeColor)
    //    print(themeColor)
    
  }
  
}

struct theme {
  
  static var themeColor = FlatGrayDark()
  
}
