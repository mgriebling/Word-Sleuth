//
//  FilterView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 20.09.2026.
//

import SwiftUI

struct FilterView: View {
	let wordList: WordList
	@Binding var filter: Filter
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	let wordRange = 3...20
	let maxWordRange = 50...200
		
    var body: some View {
		NavigationStack {
			Form {
				Section("Maximum Words (\(filter.maxWordCount))") {
					IntSlider(label: "", value: $filter.maxWordCount, range: maxWordRange, minValue: maxWordRange.lowerBound, maxValue: maxWordRange.upperBound)
				}
				
				Section("Word Length (\(filter.minWordLength) to \(filter.maxWordLength) letters)") {
					IntSlider(label: "Min:", value: $filter.minWordLength, range: wordRange, minValue: wordRange.lowerBound, maxValue: filter.maxWordLength)
					IntSlider(label: "Max:", value: $filter.maxWordLength, range: wordRange, minValue: filter.minWordLength, maxValue: wordRange.upperBound)
				}
				
				Section("Common Words") {
					Toggle(isOn: $filter.filterWords) {
						Text("Filter common words")
					}
					WordView(words: wordList.placedWords, style: .paragraph)
						.id(wordList.words)
				}
			}
			.navigationBarTitle("Word List Filter")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				EditToolbar(okDisabled: true) { dismiss() }
			}
		}
    }
}

#Preview {
	@Previewable @State var filter = Filter()
	FilterView(wordList: SampleWords.commonWords, filter: $filter)
		.environment(DataContainer())
}
