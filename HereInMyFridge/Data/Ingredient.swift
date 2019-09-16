//
//  Ingredient.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import SwiftyJSON
import Realm
import RealmSwift

class Ingredient: Object {
	
	@objc dynamic var id: Int
	@objc dynamic var name: String
	@objc dynamic var count: Double
	@objc dynamic var aisle: String
	
	// Used for sorting ingredients in database
	@objc dynamic var lastEdited: Double
	
	// Easily accessible count variable to get around DB write requirement when modifying Object variables
	var editableCount: Double {
		get {
			return self.count
		}
		
		set {
			let realm = try! Realm()
			try! realm.write {
				self.count = newValue
				self.lastEdited = Date().timeIntervalSince1970
			}
		}
	}
	
	// Required Constructors for Realm Object 
	required init() {
		self.id = -1
		self.name = ""
		self.count = 0
		self.aisle = ""
		self.lastEdited = 0.0
		
		super.init()
	}
	
	required init(realm: RLMRealm, schema: RLMObjectSchema) {
		self.id = -1
		self.name = ""
		self.count = 0
		self.aisle = ""
		self.lastEdited = 0.0
		
		super.init(realm: realm, schema: schema)
	}
	
	required init(value: Any, schema: RLMSchema) {
		self.id = -1
		self.name = ""
		self.count = 0
		self.aisle = ""
		self.lastEdited = 0.0
		
		super.init(value: value, schema: schema)
	}
	
	// Copy constructor
	init(_ ingredient: Ingredient) {
		self.id = ingredient.id
		self.name = ingredient.name
		self.count = ingredient.count
		self.aisle = ingredient.aisle
		self.lastEdited = ingredient.lastEdited
		
		super.init()
	}
	
	// Constructor for user Fridge
	init(name: String, count: Double) {
		self.id = -1
		self.name = name
		self.count = count
		self.aisle = ""
		self.lastEdited = Date().timeIntervalSince1970
		
		super.init()
	}
	
	// Instantiate w/ JSON data from server
	init(json: JSON) {
		self.id = json["id"].intValue
		self.name = json["name"].stringValue
		self.count = json["amount"].doubleValue
		self.aisle = json["aisle"].stringValue
		self.lastEdited = Date().timeIntervalSince1970
		
		super.init()
	}
	
}
