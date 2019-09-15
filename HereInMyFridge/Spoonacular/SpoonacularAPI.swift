//
//  SpoonacularAPI.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import Moya

enum SpoonacularAPI {
	
	case findRecipesByIngredients(ingredients: [Ingredient])
	case getIngredientInformation(ingredient: Ingredient)
	
}

extension SpoonacularAPI: TargetType {
	
	var baseURL: URL {
		return URL(string: "https://api.spoonacular.com/")!
	}
	
	var path: String {
		switch self {
		case .findRecipesByIngredients(_):
			return "recipes/findByIngredients"
		case .getIngredientInformation(let ingredient):
			return "food/ingredients/\(ingredient.name)/information"
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var sampleData: Data {
		return "".data(using: .utf8)!
	}
	
	var task: Task {
		switch self {
		case .findRecipesByIngredients(let ingredients):
			return .requestParameters(parameters:
				[
					"ingredients": ((ingredients.map({ $0.name })).joined(separator: ",+")),
					"apiKey": Spoonacular.apiKey
				], encoding: URLEncoding.default)
		default:
			return .requestParameters(parameters: [ "apiKey": Spoonacular.apiKey ], encoding: URLEncoding.default)
		}
	}
	
	var headers: [String : String]? {
		return nil
	}
	
}
