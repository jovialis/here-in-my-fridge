//
//  RecipesViewController.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import UIKit
import Moya
import SwiftyJSON
import TableManager

class RecipesViewController: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.rowHeight = 100
		
		// Perform search for recipes
		self.searchForRecipes()
	}
	
	private func searchForRecipes() {
		// Hit Spoonacular endpoint using Moya as the middleman
		let provider = MoyaProvider<SpoonacularAPI>()
		provider.request(.findRecipesByIngredients(ingredients: Fridge.shared.ingredients)) {
			switch $0 {
			case .success(let response):
				do {
					// Only allow successful HTTP codes
					_ = try response.filterSuccessfulStatusCodes()
					
					// Parse data as JSON
					let json = try JSON(data: response.data)
					
					// Parse each recipe's JSON
					let recipes: [Recipe] = json.arrayValue.map({ Recipe(json: $0) })
					
					self.displayRecipes(recipes: recipes)
					self.printShoppingList(recipes: recipes)
				} catch {
					print(error.localizedDescription)
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
	
	private func displayRecipes(recipes: [Recipe]) {
		// Add recipe cells for each
		recipes.forEach({ recipe in
			
			// Append row
			let row = self.tableView.addRow("recipe")
			
			row.setHeight(withStaticHeight: 100)
			
			row.setConfiguration({ (row, cell, indexPath) in
				if let cell = cell as? UIRecipeCell {
					
					// Disclosure
					cell.accessoryType = .disclosureIndicator
					
					// Set recipe name in cell
					cell.recipeNameLabel.text = recipe.name.capitalized
					
					// Whether it's doable or not
					let shoppingList = recipe.shoppingList
					
					cell.recipeDoableLabel.text = shoppingList.isEmpty ? "No Shopping Required" : "\(shoppingList.count) Ingredients Needed"
					
				}
			})
			
			row.setDidSelect({ (row, table, indexPath) in
				if let controller = self.storyboard?.instantiateViewController(withIdentifier: "shopping") as? RecipeShoppingViewController {
					controller.recipe = recipe
					self.navigationController?.pushViewController(controller, animated: true)
				}
			})
			
		})
		
		self.tableView.reloadData()
	}
	
	private func printShoppingList(recipes: [Recipe]) {
		var recipeRoot = JSON()
		
		// Iterate over received recipes
		for recipe in recipes {
			var recipeIngredientsRoot = JSON()
			
			// Set a Key Value pair for each ingredient and its aisle
			for ingredient in recipe.shoppingList {
				recipeIngredientsRoot[ingredient.name].string = ingredient.aisle
			}
			
			// Set this ingredient list object in the root
			recipeRoot[recipe.name] = recipeIngredientsRoot
		}
		
		// Print out the JSON
		print(recipeRoot)
	}
	
	
}
