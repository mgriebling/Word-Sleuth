//
//  FilterView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 20.09.2026.
//

import SwiftUI

struct FilterView: View {
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	let wordRange = 3...20
	let maxWordRange = 50...200
	
	@State private var maxWordCount = 100
	@State private var minWordLength = 4
	@State private var maxWordLength = 8
	@State private var filterWords = true
	
    var body: some View {
		NavigationStack {
			Form {
				Section("Maximum Words (\(maxWordCount))") {
					IntSlider(label: "", value: $maxWordCount, range: maxWordRange, minValue: maxWordRange.lowerBound, maxValue: maxWordRange.upperBound)
				}
				
				Section("Word Length (\(minWordLength) to \(maxWordLength) letters)") {
					IntSlider(label: "Min:", value: $minWordLength, range: wordRange, minValue: wordRange.lowerBound, maxValue: maxWordLength)
					IntSlider(label: "Max:", value: $maxWordLength, range: wordRange, minValue: minWordLength, maxValue: wordRange.upperBound)
				}
				
				Section("Common Words") {
					Toggle(isOn: $filterWords) {
						Text("Filter common words")
					}
				}
			}
			.navigationBarTitle("Word List Filter")
			.navigationBarTitleDisplayMode(.inline)
		}
		.toolbar {
			EditToolbar() {
				// settings = internalSettings
				dismiss()
			}
		}
    }
}

#Preview {
    FilterView()
}
