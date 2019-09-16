//
//  Fridge.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import Signals
import RealmSwift

class Fridge {
	
	static let shared = Fridge()
	
	// NOTE: Using an array for this is very inefficient since we have to search it every time
	//       we need an ingredient's information. The optimal solution would be a map but I'm already
	//       too deep in at this point.
	private(set) var ingredients: [Ingredient]
	
	let ingredientAdded: Signal<(Int,Ingredient)> // Index, ingredient
	let ingredientUpdated: Signal<(Int,Int,Ingredient)> // Index, old index, ingredient
	let ingredientRemoved: Signal<(Int,Ingredient)> // Index, ingredient

	fileprivate init() {
		self.ingredients = []
		
		self.ingredientAdded = Signal<(Int, Ingredient)>()
		self.ingredientUpdated = Signal<(Int, Int, Ingredient)>()
		self.ingredientRemoved = Signal<(Int, Ingredient)>()
		
		// Load ingredients to memory
		self.loadIngredients()
	}
	
	func loadIngredients() {
		// Local realm instance
		let realmInstance = try! Realm()
		
		// Append all locally stored ingredients to the array in memory. Sort by their date last edited.
		self.ingredients.append(contentsOf: realmInstance.objects(Ingredient.self).sorted(by: { $0.lastEdited > $1.lastEdited }))
	}
	
	func addIngredient(name: String, count: Double) {
		// Properly format name
		let formattedName = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		
		// Check if there are already ingredients of this type in the fridge
		if let existingIndex = self.ingredients.firstIndex(where: { $0.name == formattedName }) {
			// Remove the existing from the array, readd at start of array
			let existing = self.ingredients.remove(at: existingIndex)
			self.ingredients.insert(existing, at: 0)
			
			// Increment count
			existing.editableCount += count
			
			// Alert view controllers
			self.ingredientUpdated.fire((0, existingIndex, existing))
			return
		}
		
		// Create and add new ingredient
		let ingredient = Ingredient(name: formattedName, count: count)
		self.ingredients.insert(ingredient, at: 0)
		
		// Alert controllers
		self.ingredientAdded.fire((0, ingredient))
		
		// Write to disk
		let realm = try! Realm()
		try! realm.write {
			realm.add(ingredient)
		}
	}
	
	func editIngredientCount(name: String, count: Double) {
		if let existingIndex = self.ingredients.firstIndex(where: { $0.name == name }) {
			let existing = self.ingredients[existingIndex]
			
			// Increment count
			existing.editableCount = count
			
			// Alert view controllers
			self.ingredientUpdated.fire((existingIndex, existingIndex, existing))
		}
	}
	
	func deleteIngredient(name: String) {
		if let existingIndex = self.ingredients.firstIndex(where: { $0.name == name }) {
			let existing = self.ingredients.remove(at: existingIndex)
			
			// Alert view controllers
			self.ingredientRemoved.fire((existingIndex, existing))
			
			// Delete from file
			let realm = try! Realm()
			try? realm.write {
				realm.delete(existing)
			}
		}
	}
	
	func getIngredientCount(name: String) -> Double {
		return self.ingredients.first(where: { $0.name == name })?.editableCount ?? 0
	}
	
	// Assemble an array of missing ingredients, including ingredients the user possesses but doesn't have a sufficient amount of.
	func assembleShoppingList(recipe: Recipe) -> [Ingredient] {
		var ingredients: [Ingredient] = []
		
		// Append all missing ingredients to recipe
		ingredients.append(contentsOf: recipe.missingIngredients)
		
		for userIngredient in recipe.usedIngredients {
			let requiredCount = userIngredient.editableCount
			let userCount = self.getIngredientCount(name: userIngredient.name)
			
			// Check if the user has enough of the used ingredient
			if userCount < requiredCount {
				// Append a new Ingredient to the list representing how much more we need to purchase.
				let requiredIngredient = Ingredient(userIngredient)
				requiredIngredient.editableCount = requiredCount - userCount
				
				ingredients.append(requiredIngredient)
			}
		}
		
		return ingredients
	}
	
}
