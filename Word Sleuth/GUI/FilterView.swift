//
//  FilterView.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 20.09.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct FilterView: View {
	let wordList: [String]
	@Binding var filter: Filter
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	@State private var words = WordList()
	
	let wordRange = 3...20		// same thing here
	let maxWordRange = 50...200 // this should be a constant somewhere
		
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
					Toggle(isOn: $filter.filterCommonWords) {
						Text("Filter common words")
					}
					WordView(words: words.placedWords, style: .paragraph)
						.id(words.words)
				}
			}
			.onAppear {
				words = WordList(words: wordList)
			}
			.navigationBarTitle("Word List Filter")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				EditToolbar() { dismiss() }
			}
		}
    }
}

#Preview {
	@Previewable @State var filter = Filter()
	FilterView(wordList: SampleWords.commonWords, filter: $filter)
		.environment(DataContainer())
}
