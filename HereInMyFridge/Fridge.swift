//
//  Fridge.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import Signals

class Fridge {
	
	static let shared = Fridge()
	
	private(set) var ingredients: [Ingredient]
	
	let ingredientAdded: Signal<(Int,Ingredient)> // Index, ingredient
	let ingredientUpdated: Signal<(Int,Int,Ingredient)> // Index, old index, ingredient
	let ingredientRemoved: Signal<(Int,Ingredient)> // Index, ingredient

	fileprivate init() {
		self.ingredients = []
		
		self.ingredientAdded = Signal<(Int, Ingredient)>()
		self.ingredientUpdated = Signal<(Int, Int, Ingredient)>()
		self.ingredientRemoved = Signal<(Int, Ingredient)>()
	}
	
	func addIngredient(name: String, count: Int) {
		// Properly format name
		let formattedName = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		
		// Check if there are already ingredients of this type in the fridge
		if let existingIndex = self.ingredients.firstIndex(where: { $0.name == formattedName }) {
			// Remove the existing from the array, readd at start of array
			let existing = self.ingredients.remove(at: existingIndex)
			self.ingredients.insert(existing, at: 0)
			
			// Increment count
			existing.count += count
			
			// Alert view controllers
			self.ingredientUpdated.fire((0, existingIndex, existing))
			return
		}
		
		// Create and add new ingredient
		let ingredient = Ingredient(name: formattedName, count: count)
		self.ingredients.insert(ingredient, at: 0)
		
		// Alert controllers
		self.ingredientAdded.fire((0, ingredient))
	}
	
	func editIngredientCount(name: String, count: Int) {
		if let existingIndex = self.ingredients.firstIndex(where: { $0.name == name }) {
			let existing = self.ingredients[existingIndex]
			
			// Increment count
			existing.count = count
			
			// Alert view controllers
			self.ingredientUpdated.fire((existingIndex, existingIndex, existing))
		}
	}
	
	func deleteIngredient(name: String) {
		if let existingIndex = self.ingredients.firstIndex(where: { $0.name == name }) {
			let existing = self.ingredients.remove(at: existingIndex)
			
			// Alert view controllers
			self.ingredientRemoved.fire((existingIndex, existing))
		}
	}
	
}
