//
//  MockContainer.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 04.11.2024.
//

import SwiftData
import Foundation

@MainActor
func createPreviewModelContainer() -> ModelContainer {
	do {
		// Use an in-memory configuration for the preview
		let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: FoodRecord.self, configurations: configuration)
		let context = container.mainContext
		
		let calendar = Calendar.current
		let today = calendar.startOfDay(for: Date())
		
		// Prepare mock data
		let mockFoodRecords = [
			FoodRecord(timestamp: today.addingTimeInterval(3600 * 2), foodLevel: .medium, name: "Hot Dog"),
			FoodRecord(timestamp: today.addingTimeInterval(3600 * 5), foodLevel: .high, name: "Pizza"),
			FoodRecord(timestamp: today.addingTimeInterval(3600 * 12), foodLevel: .high, name: "Cake"),
			FoodRecord(timestamp: today.addingTimeInterval(3600 * 17), foodLevel: .low, name: "Salad"),
		]
		
		// Insert mock data into the context
		for foodRecord in mockFoodRecords {
			context.insert(foodRecord)
		}
		
		// Save the context to persist data
		try context.save()
		
		return container
	} catch {
		fatalError("Failed to create preview container: \(error)")
	}
}
