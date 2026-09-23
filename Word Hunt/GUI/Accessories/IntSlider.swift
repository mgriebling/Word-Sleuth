//
//  IntSlider.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 20.09.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//
import SwiftUI

struct IntSlider: View {
	let label: String
	@Binding var value: Int
	let range: ClosedRange<Int>
	let minValue: Int
	let maxValue: Int
	
	@State private var fvalue: Double = 3

	var body: some View {
		HStack {
			Text(label)
			Slider(value: Binding(
				get: { Double(value) },
				set: { value = max(minValue, min(maxValue, Int($0))) }
			),
				   in: Double(range.lowerBound) ... Double(range.upperBound),
				   step: 1.0)
			{
				Text("")
			} minimumValueLabel: {
				Text("\(range.lowerBound)")
			} maximumValueLabel: {
				Text("\(range.upperBound)")
			}
		}
	}
}

#Preview {
	@Previewable @State var value: Int = 3
	IntSlider(label: "Max:", value: $value, range: 2...10, minValue: 2, maxValue: 10)
}
