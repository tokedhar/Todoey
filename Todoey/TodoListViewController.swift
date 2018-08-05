//
//  ViewController.swift
//  Todoey
//
//  Created by Kedharanath R on 29/7/18.
//  Copyright © 2018 Kedharanath R. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemArray = ["Find Mike", "Buy Eggoes", "Destroy Demogorgon"]
	let defaults = UserDefaults()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		if let items = defaults.array(forKey: "TodoListArray") as? [String] {
			itemArray = items
		}
	}
	
	//MARK - TableView Datasource Methods:
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		cell.textLabel?.text = itemArray[indexPath.row]
		
		return cell
	}
	
	//MARK - TableView Delegate Methods:
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//print(itemArray[indexPath.row])
		
		if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		
		//Originally after clicking, the row is selected highlighting in gray.  With this addition,
		//the row will shortly show highlighting and then go back to unhighlighted:
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK - Add New Items:
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		var textField = UITextField()
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (alert) in
			//What will happen once the user clicks the Add Item button on our UIAlert
			self.itemArray.append(textField.text!)
			
			self.defaults.set(self.itemArray, forKey: "TodoListArray")
			
			self.tableView.reloadData()
		}
		
		//Add a text field in the alert popup:
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		

		

		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	
}

