//
//  AddItem.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 12.10.2024.
//

import SwiftUI

struct AddItemView: View {
	@Environment(\.modelContext) private var modelContext
	@State var foodDescription: String = ""
	@State var foodLevel: Int = 1
	@Binding var datepicker: Date
	@State var foodRecord: FoodRecord?
	@FocusState private var isTextFieldFocused: Bool
	@Environment(\.dismiss) private var dismiss
	
	init(datepicker: Binding<Date>) {
		self._datepicker = datepicker
	}
	
	init(foodRecord: FoodRecord) {
		self.foodRecord = foodRecord
		self._datepicker = .constant(foodRecord.timestamp)
		self._foodDescription = .init(initialValue: foodRecord.name ?? "Didnt find it")
		self._foodLevel = .init(initialValue: foodRecord.foodLevel.rawValue)
	}
	
	var body: some View {
		VStack {
			DatePicker("Date", selection: $datepicker)
			TextField("Food descrption",
					  text: $foodDescription)
			.frame(height: 50)
			.focused($isTextFieldFocused)
			.onAppear {
				isTextFieldFocused = true
				let currentDate = Date()
				let currentCalendar = Calendar.current
				let currentHour = currentCalendar.component(.hour, from: currentDate)
				let currentMinute = currentCalendar.component(.minute, from: currentDate)
				if let modifiedDate = currentCalendar.date(bySettingHour: currentHour, minute: currentMinute, second: 0, of: datepicker) {
					datepicker = modifiedDate
				}
			}
			.padding(10) // Inner padding for text
			.background(Color.gray.opacity(0.1)) // Light background color
			.cornerRadius(20) // Rounded corners
			Picker("Food Level", selection: $foodLevel) {
				ForEach(FoodLevel.allCases) { level in
					Text(level.description).tag(level)
				}
			}
			.pickerStyle(.wheel)
			.sensoryFeedback(.levelChange, trigger: foodLevel)
			Button {
				if let foodRecord {
					foodRecord.timestamp = datepicker
					foodRecord.foodLevel = FoodLevel(rawValue: foodLevel) ?? .medium
					foodRecord.name = foodDescription
					dismiss()
				} else if let foodLevel = FoodLevel(rawValue: foodLevel) {
					let newFoodRecord = FoodRecord(timestamp: datepicker, foodLevel: foodLevel, name: foodDescription)
					modelContext.insert(newFoodRecord)
					try? modelContext.save()
					dismiss()
				}
				
			} label: {
				Text("Save")
					.font(.headline) // Font styling
					.foregroundColor(.white) // Text color
					.padding() // Add padding inside the button
					.frame(maxWidth: .infinity) // Optional: make it fill horizontally
					.background(Color.blue) // Background color
					.cornerRadius(20) // Rounded corners
			}
			
		}
		.padding(30)
	}
}

#Preview {
	AddItemView(datepicker: .constant(Date()))
}
