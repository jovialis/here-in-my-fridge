//
//  Recipe.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Recipe {
	
	let id: Int
	let name: String
	
	let usedIngredients: [Ingredient]
	let missingIngredients: [Ingredient]
	
	// Recipes will only ever be instantiated in response to the server
	init(json: JSON) {		
		self.id = json["id"].intValue
		self.name = json["title"].stringValue
		
		self.usedIngredients = json["usedIngredients"].arrayValue.map({ Ingredient(json: $0) })
		self.missingIngredients = json["missedIngredients"].arrayValue.map({ Ingredient(json: $0) })
	}
	
	var shoppingList: [Ingredient] { return Fridge.shared.assembleShoppingList(recipe: self) }
	
	var userHasAllIngredients: Bool { return self.shoppingList.isEmpty }
	
}
