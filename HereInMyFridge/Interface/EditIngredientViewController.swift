//
//  EditIngredientViewController.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import UIKit
import Signals

class EditIngredientViewController: UIViewController {
	
	var ingredient: Ingredient!
	
	@IBOutlet weak var ingredientNameLabel: UILabel!
	@IBOutlet weak var ingredientCountLabel: UILabel!
	
	@IBOutlet weak var countStepper: UIStepper!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set up initial values
		self.ingredientNameLabel.text = self.ingredient.name.capitalized
		self.ingredientCountLabel.text = "\(self.ingredient.count)"
		self.countStepper.setValue(self.ingredient.count, forKey: "value")
		
		// Increment stepper
		self.countStepper.onValueChanged.subscribe(with: self, callback: {
			self.ingredientCountLabel.text = "\(Int(self.countStepper.value))"

			// Update count, triggering signals
			Fridge.shared.editIngredientCount(name: self.ingredient.name, count: self.countStepper.value)
		})
	}
	
	@IBAction func onDeleteClicked(_ sender: Any) {
		// Pop to previous menu
		self.navigationController!.popViewController(animated: true)
		
		Fridge.shared.deleteIngredient(name: self.ingredient.name)
	}
	
}
