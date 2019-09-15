//
//  Spoonacular.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation

class Spoonacular {
	
	static var apiKey: String {
		return Bundle.main.object(forInfoDictionaryKey: "SpoonacularAPIKey") as! String
	}
	
}
