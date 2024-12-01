//
//  ColorCalculator.swift
//  FoodDiaryApp
//
//  Created by Štěpán Pazderka on 03.11.2024.
//

import UIKit

class ColorCalculator {
	
	// Define the gradient colors and range
	let colorLow = UIColor.green    // Start of the gradient
	let colorMid = UIColor.yellow   // Middle of the gradient
	let colorHigh = UIColor.red     // End of the gradient
	
	let minValue: Float = 0                // Minimum value in your range
	let maxValue: Float = 2               // Maximum value in your range
	
	// Function to calculate the color based on the average
	func colorForAverage(_ average: Float) -> UIColor {
		// Normalize the average value to a 0...1 range
		let normalizedValue = CGFloat(average - minValue) / CGFloat(maxValue - minValue)
		
		// Ensure the normalized value is clamped to the range 0...1
		let clampedValue = min(max(normalizedValue, 0), 1)
		
		// Determine if we're in the green-yellow or yellow-red part of the gradient
		if clampedValue <= 0.5 {
			// Interpolate between green and yellow
			let fraction = clampedValue / 0.5
			return interpolateColor(from: colorLow, to: colorMid, fraction: fraction)
		} else {
			// Interpolate between yellow and red
			let fraction = (clampedValue - 0.5) / 0.5
			return interpolateColor(from: colorMid, to: colorHigh, fraction: fraction)
		}
	}
	
	// Linear interpolation between two colors
	func interpolateColor(from startColor: UIColor, to endColor: UIColor, fraction: CGFloat) -> UIColor {
		var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
		var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
		
		startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
		endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
		
		let red = startRed + (endRed - startRed) * fraction
		let green = startGreen + (endGreen - startGreen) * fraction
		let blue = startBlue + (endBlue - startBlue) * fraction
		let alpha = startAlpha + (endAlpha - startAlpha) * fraction
		
		return UIColor(red: red, green: green, blue: blue, alpha: alpha)
	}
}
