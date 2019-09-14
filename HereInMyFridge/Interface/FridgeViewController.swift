//
//  ViewController.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import UIKit
import TableManager

class FridgeViewController: UITableViewController {

	private var ingredientsSection: Section!
	
	@IBOutlet weak var findRecipeButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register ingredient cell nib
		self.tableView.register(UINib(nibName: "UIIngredientCell", bundle: nil), forCellReuseIdentifier: "ingredient")
		
		// Link Fridge updates
		Fridge.shared.ingredientAdded.subscribe(with: self) { index, ingredient in
			self.reloadIngredientsSection()
		}
		
		Fridge.shared.ingredientUpdated.subscribe(with: self) { index, oldIndex, ingredient in
			self.reloadIngredientsSection()
		}
		
		Fridge.shared.ingredientRemoved.subscribe(with: self) { index, ingredient in
			self.reloadIngredientsSection()
		}
		
		// Add search button
		self.tableView.addRow("search").setConfiguration({ row, cell, indexPath in
			// Automatic resizing
			row.setHeightAutomatic()
		})
		
		// Add section for ingredients
		let ingredientSection = self.tableView.addSection()
		
		ingredientSection.titleForHeader = {_,_,_ in
			return "Your Ingredients"
		}
		
		self.ingredientsSection = ingredientSection
		
		// Add ingredient cells
		self.reloadIngredientsSection()
	}
	
	func reloadIngredientsSection() {
		self.ingredientsSection.clearRows()
		
		// Add cell for each ingredient in the fridge
		Fridge.shared.ingredients.forEach({ ingredient in
			
			let row = self.ingredientsSection.addRow("ingredient")
			self.configureIngredientRow(row: row, ingredient: ingredient)
			
		})
		
		// Reload table
		self.tableView.reloadSections([1], with: .fade)
	}
	
	// Shared method to configure an ingredient cell with a given incredient
	private func configureIngredientRow(row: Row, ingredient: Ingredient) {
		row.setConfiguration({row, cell, indexPath in
			guard let cell = cell as? UIIngredientCell else {
				return
			}
			
			// Disclosure arrow
			cell.accessoryType = .disclosureIndicator
			
			cell.ingredientNameLabel.text = ingredient.name.capitalized
			cell.ingredientCountLabel.text = "\(ingredient.count)"
		})
		
		row.setDidSelect({row, cell, indexPath in
			if let controller = self.storyboard?.instantiateViewController(withIdentifier: "edit") as? EditIngredientViewController {
				controller.ingredient = ingredient
				
				self.navigationController?.pushViewController(controller, animated: true)
			}
		})
	}
	
	@IBAction func findRecipesClicked(_ sender: UIButton) {
		//TODO: Web call
	}
	
	@IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
		if let addController = self.storyboard?.instantiateViewController(withIdentifier: "Add") {
			self.present(addController, animated: true, completion: nil)
		}
	}
	
}

