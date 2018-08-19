//
//  ViewController.swift
//  Todoey
//
//  Created by Kedharanath R on 29/7/18.
//  Copyright © 2018 Kedharanath R. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]() //["Find Mike", "Buy Eggoes", "Destroy Demogorgon"]
	
	let defaults = UserDefaults.standard
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		print(dataFilePath)
		
//		let newItem = Item()
//		newItem.title = "Find Mike"
//		itemArray.append(newItem)
//
//		let newItem2 = Item()
//		newItem2.title = "Buy Eggoes"
//		itemArray.append(newItem2)
//
//		let newItem3 = Item()
//		newItem3.title = "Destroy Demogorgon"
//		itemArray.append(newItem3)
		
		//		if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
		//			itemArray = items
		//		}
		loadItems()
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
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		//		tableView.reloadData()
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
			let newItem = Item()
			
			newItem.title = textField.text!
			
			self.itemArray.append(newItem)
			
			//			self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
		
		let encoder = PropertyListEncoder()
		
		do {
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error encoding item array, \(error)")
			
		}
		
		self.tableView.reloadData()
	}
	
	func loadItems() {
		
		if let data = try? Data(contentsOf: dataFilePath!) {
			let decoder = PropertyListDecoder()
			do {
			itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("Error decoding item array, \(error)")
			}
		}
	}
	
}

