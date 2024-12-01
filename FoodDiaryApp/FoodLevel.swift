//
//  FoodLevel.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 12.10.2024.
//

import SwiftUI

enum FoodLevel: Int, Identifiable, Codable, CaseIterable {
	case low
	case medium
	case high
	
	var id: Int { rawValue }
	var description: String {
		switch self {
		case .low: return "Low"
		case .medium: return "Medium"
		case .high: return "High"
		}
	}
	var color: Color {
		switch self {
		case .low: return .green
		case .medium: return .yellow
		case .high: return .red
		}
	}
}
