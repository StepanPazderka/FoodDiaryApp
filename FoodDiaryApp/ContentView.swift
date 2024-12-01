//
//  ContentView.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 12.10.2024.
//

import SwiftUI
import SwiftData
import HorizonCalendar

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@State var selectedDate: Date = Date()
	@Query var items: [FoodRecord]
	var showingItems: [FoodRecord] {
		return items.filter {
			let calendar = Calendar.current
			return calendar.isDate($0.timestamp, inSameDayAs: selectedDate)
		}.sorted{ $0.timestamp < $1.timestamp }
	}
	@State var showingAddItem: Bool = false
	@State var selectedFoodRecord: FoodRecord?
	@State var selectedDayDegrees: Double = 0
	@State var todayDegrees: Double = 0
//	@State var visibleDayRange = DayComponentsRange(uncheckedBounds: (lower: DayComponents(month: MonthComponents(era: 0, year: <#T##Int#>, month: <#T##Int#>, isInGregorianCalendar: <#T##Bool#>), day: <#T##Int#>), upper: DayComponents))
	
	var startDate: Date {
		Calendar.current.date(byAdding: .year, value: -1, to: Date())!
	}
	
	var endDate: Date {
		Calendar.current.date(byAdding: .year, value: 1, to: Date())!
	}
	
	@StateObject var viewModel = ContentViewModel()
	
	var body: some View {
		let calendar = Calendar.current

		DynamicStack {
			let config = HorizontalMonthsLayoutOptions.PaginationConfiguration(restingPosition: .atIncrementsOfCalendarWidth, restingAffinity: .atPositionsAdjacentToPrevious)
			let scrollingBehavior = HorizontalMonthsLayoutOptions.ScrollingBehavior.paginatedScrolling(config)
			let layout = HorizontalMonthsLayoutOptions(maximumFullyVisibleMonths: 1, scrollingBehavior: scrollingBehavior)
			CalendarViewRepresentable(
				calendar: calendar,
				visibleDateRange: startDate...endDate,
				monthsLayout: .horizontal(options: layout),
				dataDependency: [selectedDayDegrees, todayDegrees],
				proxy: viewModel.proxy)
			.onDaySelection({ day in
				selectedDate = calendar.date(from: day.components)!
				selectedFoodRecord = nil
			})
			.days { [selectedDate] day in
				let date = calendar.date(from: day.components)
				
				ZStack {
					if let date, calendar.isDate(date, inSameDayAs: Date()) {
						Circle()
							.stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 4]))
							.foregroundStyle(.blue)
							.rotationEffect(.degrees(todayDegrees))
					} else if date == selectedDate {
						Circle()
							.trim(from: 0, to: 1)
							.stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [6, 4]))
							.foregroundStyle(.blue)
							.opacity(0.3)
							.rotationEffect(.degrees(selectedDayDegrees))
					}
					Text("\(day.day)")
						.font(.system(size: 18))
						.foregroundColor(Color(UIColor.label))
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
				.padding(5)
				.background {
					Circle()
						.fill(Color(color(for: date)))
						.padding(5)
				}
			}
			.onScroll {visibleDayRange, isUserDragging in
				print("Visible Date Range:")
				print(visibleDayRange)
				var finished = false
				if !isUserDragging, !finished {
					finished = true
				}
				print(isUserDragging)
			}
			.padding(10)
			.onAppear {
				viewModel.scrollToToday(withAnimation: false)
			}
			
			NavigationSplitView {
				List(selection: $selectedFoodRecord) {
					ForEach(showingItems, id: \.self) { item in
						HStack {
							Circle()
								.frame(width: 16, height: 16)
								.foregroundStyle(item.foodLevel.color)
							Text(item.timestamp, format: Date.FormatStyle(date: .none, time: .shortened))
							if let name = item.name {
								Text(name)
							}
						}
					}
					.onDelete(perform: deleteItems)
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button {
							viewModel.scrollToToday(withAnimation: true)
							selectedDate = Date()
						} label: {
							Label("Today", systemImage: "calendar")
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						EditButton()
					}
					ToolbarItem {
						Button(action: addItem) {
							Label("Add Item", systemImage: "plus")
						}
					}
				}
			} detail: {
				if let selectedFoodRecord {
//					FoodView(food: selectedFoodRecord)
					AddItemView(foodRecord: selectedFoodRecord)
				} else {
					Text("Select an item")
				}
			}
			.scrollContentBackground(.hidden)
		}
		.sheet(isPresented: $showingAddItem) {
			AddItemView(datepicker: $selectedDate)
		}
		.onAppear {
			Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
				if calendar.isDate(selectedDate, inSameDayAs: Date()) {
					todayDegrees -= 0.02
				}
				
				if !calendar.isDate(selectedDate, inSameDayAs: Date()) {
					selectedDayDegrees -= 0.02
				}
			}
		}
	}
	
	private func addItem() {
		showingAddItem = true
	}
	
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			for index in offsets {
				let foodRecord = showingItems[index]
				modelContext.delete(foodRecord)
			}
			try? modelContext.save()
		}
	}
	
	private func color(for date: Date?) -> UIColor {
		let calendar = Calendar.current
		guard let date else { return .clear }
		let foodRecordsForDay = items.filter { calendar.isDate(date, inSameDayAs: $0.timestamp) }
		if !foodRecordsForDay.isEmpty {
			let average = Float(foodRecordsForDay.reduce(0) {
				return $0 + $1.foodLevel.rawValue
			}) / Float(foodRecordsForDay.count)
			let colorCalculator = ColorCalculator()
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMMM dd"
			
//			print("\(dateFormatter.string(from: date)): \(average)")
			for foodRecord in foodRecordsForDay   {
//				print("Food Records: \(foodRecord.foodLevel.rawValue)")
			}
			return colorCalculator.colorForAverage(average)
		}
		
		return .clear
	}
}

#Preview {
	ContentView()
		.modelContainer(createPreviewModelContainer())
}
