//
//  AddIngredientViewController.swift
//  HereInMyFridge
//
//  Created by Dylan Hanson on 9/14/19.
//  Copyright © 2019 Jovialis. All rights reserved.
//

import Foundation
import UIKit
import Signals

class AddIngredientViewController: UIViewController {
	
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var countStepper: UIStepper!
	
	@IBOutlet weak var countLabel: UILabel!
	
	private var name: String {
		return self.nameTextField.text ?? ""
	}
	
	private var count: Int {
		return Int(self.countStepper.value)
	}
	
	// Whether the item can be accepted yet
	private var valid: Bool {
		return self.name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
		&& self.count > 0
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set default values
		self.nameTextField.text = ""
		self.countStepper.value = 0.0
		
		self.countLabel.text = "0"
		
		self.doneButton.isEnabled = false
		
		// Update label
		self.countStepper.onValueChanged.subscribe(with: self) {
			self.countLabel.text = "\(Int(self.countStepper.value))"
		}
		
		// Update of done button
		self.countStepper.onValueChanged.subscribe(with: self) {
			self.updateDoneButton()
		}
		
		self.nameTextField.onValueChanged.subscribe(with: self) {
			self.updateDoneButton()
		}
		
		self.nameTextField.onEditingChanged.subscribe(with: self) {
			self.updateDoneButton()
		}
	}
	
	private func updateDoneButton() {
		self.doneButton.isEnabled = self.valid
	}
	
	@IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
		// Dismiss view controller
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
		// Only accept if the contents are valid
		if !self.valid {
			return
		}
		
		// Dismiss controller. Add food to repository after for clean animation.
		self.dismiss(animated: true, completion: {
			Fridge.shared.addIngredient(name: self.name, count: self.count)
		})
	}
	
}
