//
//  ViewController.swift
//  Todoey
//
//  Created by Kedharanath R on 29/7/18.
//  Copyright © 2018 Kedharanath R. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	
	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	
	let defaults = UserDefaults.standard
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
		
	}
	
	
	//MARK - TableView Datasource Methods:
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		let item = itemArray[indexPath.row]
		cell.textLabel?.text = item.title
		
		cell.accessoryType = item.done ? .checkmark : .none
		
		return cell
	}
	
	
	//MARK - TableView Delegate Methods:
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		context.delete(itemArray[indexPath.row])
		itemArray.remove(at: indexPath.row)
		//itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		self.saveItems()
		
		//Originally after clicking, the row is selected highlighting in gray.  With this addition, the row will shortly show highlighting and then go back to unhighlighted:
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	//MARK - Add New Items:
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		var textField = UITextField()
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (alert) in
			//What will happen once the user clicks the Add Item button on our UIAlert
			let newItem = Item(context: self.context)
			newItem.title = textField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			self.itemArray.append(newItem)
			self.saveItems()
		}
		
		//Add a text field in the alert popup:
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	//MARK - Model Manipulation Methods
	
	func saveItems() {
		
		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		
		do {
			itemArray = try context.fetch(request)
		} catch {
			print("Error fetching data from context \(error)")
		}
		
		tableView.reloadData()
	}
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadItems(with: request, predicate: predicate)
		
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

