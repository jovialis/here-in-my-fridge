//
//  Ingredient.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import SwiftyJSON

class Ingredient {
	
	let id: Int
	let name: String
	var count: Int
	let aisle: String
	
	// Copy constructor
	init(_ ingredient: Ingredient) {
		self.id = ingredient.id
		self.name = ingredient.name
		self.count = ingredient.count
		self.aisle = ingredient.aisle
	}
	
	// Constructor for user Fridge
	init(name: String, count: Int) {
		self.id = -1
		self.name = name
		self.count = count
		self.aisle = ""
	}
	
	// Instantiate w/ JSON data from server
	init(json: JSON) {
		self.id = json["id"].intValue
		self.name = json["name"].stringValue
		self.count = json["amount"].intValue
		self.aisle = json["aisle"].stringValue
	}
	
}
