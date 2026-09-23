//
//  WordListSummary.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 23.06.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct WordListSummary: View {
	let wordList: WordList
	
	@Environment(\.horizontalSizeClass) var size
	
	var body: some View {
		let isCompact: Bool = size == .compact
		VStack(alignment: .leading) {
			Text(wordList.name + " List").font(isCompact ? .title2 : .title)
			let author = wordList.author.isEmpty ? "Anonymous" : wordList.author
			if isCompact && author != "Anonymous" && author != "Unknown" {
				Text("Author: \(wordList.author)")
			}
			if !isCompact {
				Text("Created: \(wordList.date, format: .dateTime.day().month().year())")
			}
			Text("\(wordList.words.count) words (\(wordList.language.description))")
			Text("Words: (Average/Maximum \(wordList.averageLength, specifier: "%.1f")/\(wordList.maxLength) letters)")
			Text(wordList.words.map({ $0.capitalized }).joined(separator: ", "))
					.font(.caption)
					.lineLimit(isCompact ? 2 : nil)
		}
		.padding(.horizontal)
	}
}

#Preview {
	@Previewable @State var wordList = SampleWords.list.randomElement()!
    WordListSummary(wordList: wordList)
}
