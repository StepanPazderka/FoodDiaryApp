//
//  Item.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 12.10.2024.
//

import Foundation
import SwiftData

@Model
final class FoodRecord {
    var timestamp: Date
	var foodLevel: FoodLevel
	var name: String?
    
	init(timestamp: Date, foodLevel: FoodLevel, name: String?) {
		self.timestamp = timestamp
		self.foodLevel = foodLevel
		self.name = name
	}
}
