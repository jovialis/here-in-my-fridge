//
//  RecipeShoppingViewController.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import UIKit
import TableManager

class RecipeShoppingViewController: UITableViewController {
	
	var recipe: Recipe!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register Ingredient nib
		self.tableView.register(UINib(nibName: "UIIngredientCell", bundle: nil), forCellReuseIdentifier: "ingredient")
		
		// Set up table view for shopping list
		self.recipe.shoppingList.forEach({ ingredient in
			
			let row = self.tableView.addRow("ingredient")
			
			row.setHeight(withStaticHeight: 75.0)
			
			// Configure cell
			row.setConfiguration({ row, cell, indexPath in
				if let cell = cell as? UIIngredientCell {
					
					// Set up cell
					cell.ingredientNameLabel.text = ingredient.name.capitalized
					cell.ingredientCountLabel.text = "You must buy \(ingredient.editableCount)"
					
					cell.ingredientAisleLabel.isHidden = false
					cell.ingredientAisleLabel.text = "in the \(ingredient.aisle) Aisle"
					
				}
			})
			
		})
		
		self.tableView.reloadData()
	}
	
}
