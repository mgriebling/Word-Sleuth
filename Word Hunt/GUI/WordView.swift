//
//  WordView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 23.06.2026.
//

import SwiftUI
import Algorithms

struct WordView: View {
	let words: [PlacedWord]
	var style: TextStyle = .columns
	var maxWordLength: Int = 10

	@State private var isPhone = UIDevice.current.userInterfaceIdiom == .phone
	
	@Environment(DataContainer.self) private var dataContainer
	@AppStorage(.settings) private var settings

	var body: some View {
		Group {
			if style == .columns {
				wordColumns
			} else {
				HStack {
					concatenatedText
					Spacer()
				}
			}
		}
		.fontWeight(.regular)
	}
	
	@ViewBuilder
	private var wordColumns: some View {
		ViewThatFits(in: .horizontal) {
			if words.count > 10 {
				if !dataContainer.isLandscape {
					columnText(6)
					columnText(5)
					columnText(4)
				}
				columnText(3)
				columnText(2)
			}
			columnText(1)
		}
	}
	
	@ViewBuilder
	private func columnText(_ maxColumns: Int) -> some View {
		let colWidth = CGFloat(10 * maxWordLength)
		HStack(alignment: .top, spacing: 0) {
			VStack {
				Text("Words (\(words.count))")
					.font(.system(size: isPhone ? 15 : 20, weight: .bold).lowercaseSmallCaps())
					.fixedSize(horizontal: true, vertical: false)
					.foregroundStyle(Color(.systemGray))
					.rotationEffect(Angle(degrees: 270))
					.padding(.top, isPhone ? 35 : 45)
			}
			.frame(maxWidth: 50)

			if settings.sortAcrossCols {
				sortedAcross(maxColumns: maxColumns)
			} else {
				sortedDown(maxColumns: maxColumns)
			}
		}
		.frame(minWidth: CGFloat(maxColumns) * colWidth, maxHeight: CGFloat(words.count / maxColumns) * (isPhone ? 35 : 45))
	}
	
	@ViewBuilder
	private func sortedAcross(maxColumns: Int) -> some View {
		let colWidth = CGFloat(10 * maxWordLength)
		let columns = Array(repeating:GridItem(.flexible(minimum: colWidth)), count: maxColumns)
		ScrollView(.vertical) {
			LazyVGrid(columns: columns, alignment: .leading) {
				ForEach(words, id: \.self) { word in
					PlacedWordView(word: word)
				}
			}
		}
	}
	
	@ViewBuilder
	private func sortedDown(maxColumns: Int) ->	some View  {
		let wordChunks = chunked(words, cols: maxColumns)
		let colWidth = CGFloat(10 * maxWordLength)
		ScrollView(.vertical) {
			HStack {
				ForEach(wordChunks, id: \.self) { chunk in
					VStack(alignment: .leading) {
						ForEach(chunk, id: \.self) { word in
							PlacedWordView(word: word)
								.frame(minWidth: colWidth, alignment: .leading)
						}
					}
				}
			}
		}
	}
	
	private func chunked(_ words: [PlacedWord], cols: Int) -> ChunksOfCountCollection<[PlacedWord]> {
		var words = words
		
		// even out the columns
		while words.count.isMultiple(of: cols) == false {
			words.append(PlacedWord(word: "\u{2009}"))  // add thin space
		}
		return words.chunks(ofCount: words.count / cols)
	}
	
	private func wordList() -> some View {
		ForEach(words.indices, id: \.self) { index in
			let word = words[index]
			let textColor = word.highlighted ? Color(.gray) : .primary
			Text(word.word.capitalized)
				.foregroundColor(textColor)
				.strikethrough(word.highlighted)
				.allowsTightening(true)
				.lineLimit(1)
		}
	}
	
	// Reduces the array into a single concatenated Text view
	// From Goggle AI
	private var concatenatedText: Text {
		guard !words.isEmpty else { return Text(verbatim: "") }
		return words.enumerated().reduce(Text(verbatim: "")) { result, item in
			let (index, word) = item
			let textColor = word.highlighted ? Color(.gray) : .primary
			
			// 1. Create the styled word view
			let wordText = Text(word.word.capitalized)
				.foregroundColor(textColor)
				.strikethrough(word.highlighted)
			
			// 2. Add a comma and space if it is not the last item
			let separator = index < words.count - 1 ?
			Text(verbatim: ", ").foregroundColor(textColor) : Text(verbatim: "")
			
			// 3. Concatenate to the running result
			return result + wordText + separator
		}
	}
	
	enum TextStyle {
		case columns, paragraph
	}
}

#Preview {
	let words: [PlacedWord] =
		SampleWordLists.all[10].words.enumerated().map { index, word in
			PlacedWord(word: word, highlighted: Bool.random() ? -1 : 0)
		}
//	let words2: [PlacedWord] =
//	SampleWordLists.all[4].words.enumerated().map { index, word in
//		PlacedWord(word: word, highlighted: Bool.random() ? -1 : 0)
//	}
	WordView(words: words, style: .columns, maxWordLength: SampleWordLists.all[10].maxLength)
//	WordView(words: words2, style: .columns, maxWordLength: SampleWordLists.all[4].maxLength)
	WordView(words: words, style: .paragraph)
}


