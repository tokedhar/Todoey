//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kedharanath R on 9/9/18.
//  Copyright © 2018 Kedharanath R. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

	var categoryArray = [Category]()

	var selectedCategory: Category? {
		didSet{
			loadCategories()
			
		}
	}
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
        super.viewDidLoad()

		loadCategories()
		
    }
	
	//MARK: - TableView Datasource Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoryArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		
		let category = categoryArray[indexPath.row]
		cell.textLabel?.text = category.name
		
		return cell
	}
	
	//MARK: - Data Manipulation Methods
	
	func saveCategories() {
		
		do {
			try context.save()
		} catch {
			print("Errory saving category \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	func loadCategories(request: NSFetchRequest<Category> = Category.fetchRequest()) {
		
		do {
			categoryArray = try context.fetch(request)
		} catch {
			print("Error loading categories \(error)")
		}
		
		tableView.reloadData()
	}
	
	//MARK: - Add New Categories
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
	
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		
		var textField = UITextField()
		
		let action = UIAlertAction(title: "Add", style: .default) { (alert) in
			
			let newCategory = Category(context: self.context)
			
			newCategory.name = textField.text!
			self.categoryArray.append(newCategory)
			self.saveCategories()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Add a new category"
			textField = alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
		
	}


	//MARK: - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		performSegue(withIdentifier: "goToItems", sender: self)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categoryArray[indexPath.row]
		}
	}
	
}
