//
//  FoodView.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 28.10.2024.
//

import SwiftUI

struct FoodView: View {
	@State var food: FoodRecord?
	
    var body: some View {
		if let food {
			Text(food.timestamp.description)
		} else {
			Text("No food selected")
		}
    }
}

#Preview {
    FoodView()
}
