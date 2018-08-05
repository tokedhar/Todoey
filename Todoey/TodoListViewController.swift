//
//  ViewController.swift
//  Todoey
//
//  Created by Kedharanath R on 29/7/18.
//  Copyright © 2018 Kedharanath R. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	let itemArray = ["Find Mike", "Buy Eggoes", "Destroy Demogorgon"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
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
	
}

