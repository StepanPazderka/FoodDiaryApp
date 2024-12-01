//
//  ContentViewModel.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 03.11.2024.
//

import SwiftUI
import HorizonCalendar

class ContentViewModel: ObservableObject {
	@Published var proxy = CalendarViewProxy()
	
	func scrollToToday(withAnimation: Bool) {
		proxy.scrollToMonth(containing: Date(), scrollPosition: .centered, animated: withAnimation)
	}
}
