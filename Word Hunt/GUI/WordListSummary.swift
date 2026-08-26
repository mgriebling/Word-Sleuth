//
//  WordListSummary.swift
//  Word Hunt
//
//  Created by Michael Griebling on 23.06.2026.
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
			Text("^[\(wordList.words.count) word](inflect: true) (\(wordList.language.description))")
			Text("Words: (Average/Maximum \(wordList.averageLength, specifier: "%.2f")/\(wordList.maxLength) letters)")
			Text(wordList.words.map({ $0.capitalized }).joined(separator: ", "))
					.font(.caption)
					.lineLimit(isCompact ? 2 : nil)
		}
		.padding(.horizontal)
	}
}

#Preview {
	@Previewable @State var wordList = SampleWordLists.all.randomElement()!
    WordListSummary(wordList: wordList)
}
