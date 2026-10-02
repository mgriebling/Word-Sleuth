//
//  WordsEditor.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 22.06.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct WordsEditor: View {
	@Binding var words: WordList?
	
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var lwords = WordList()
	@State private var name = ""
	@State private var wordList = [PlacedWord]()
	@State private var selectedLanguage = Language(rawValue: Locale.current.identifier) ?? .english
	@State private var editWordList = false
	@State private var useFilter = false
	@State private var editing = false
	@State private var filter = Filter()
	@State private var randomWords = false
	@State private var importString = ""
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Word List Name") {
					if editing {
						TextField("Word List Name", text: $lwords.name)
							.autocorrectionDisabled(true)
							.showClearButton($lwords.name)
					} else {
						Text(lwords.name)
					}
				}
				Section("Author") {
					if editing {
						TextField("Author", text: $lwords.author)
							.autocorrectionDisabled(true)
							.showClearButton($lwords.author)
					} else {
						Text(lwords.author)
					}
				}
				Section("Creation Date") {
					if editing {
						DatePicker("Date", selection: $lwords.date,
								   displayedComponents: [.date])
					} else {
						Text(lwords.date, format: .dateTime.day().month().year())
					}
				}
				Section("Language") {
					if editing {
						Picker("Language", selection: $lwords.language) {
							ForEach(Language.allCases, id: \.self) { language in
								Text(language.description.capitalized).tag(language)
							}
						}
					} else {
						Text(lwords.language.description)
					}
				}
				Section(header:
					VStack(alignment: .leading) {
					Text("Words (\(lwords.words.count)) \(editing ? "*Tap List to Edit*" : "")")
						if editing {
							Text("**Warning: Importing or pasting deletes existing words!**")
								.font(.caption)
								.foregroundStyle(.red)
						}
					}
				) {
					if editing {
						HStack {
							TextImportButton(name: "Text", text: $importString)
							
							PasteButton(payloadType: String.self) { strings in
								if let firstText = strings.first {
									importString = firstText
								}
							}
							.buttonBorderShape(.capsule)
							let randomText = String(localized: "Dynamically filled with \(filter.maxWordCount) random words")
							Button("Random") {
								let low = filter.minWordLength
								let high = filter.maxWordLength
								lwords = WordList(name: "Random \(low)-\(high)", wordRange: low...high, totalWords: filter.maxWordCount)
								lwords.words = [randomText]
							}
							
							Button(action: { useFilter.toggle() }) {
								Image(systemName: "gearshape.fill")
							}
						}
						.buttonStyle(.borderedProminent)
						.onChange(of: importString) {
							/// process text string to produce a unique array of words
							withAnimation {
								filter.filterCommonWords = true
								lwords = WordList(name: lwords.name, author: lwords.author, from: importString, using: filter)
							}
						}
					}
					
					WordView(words: wordList, style: .paragraph)
						.id(lwords.words)
						.onTapGesture {
							editWordList.toggle()
						}
						.sheet(isPresented: $editWordList) {
							StringList(title: lwords.name, strings: $lwords.words)
						}
				}
				.onChange(of: lwords.words) { oldValue, newValue in
					// print("Refreshing wordList...")
					wordList = lwords.words.sorted().map { PlacedWord(word: $0) }
				}
			}
			.sheet(isPresented: $useFilter) {
				FilterView(wordList: SampleWords.commonWords, filter: $filter)
			}
			.navigationTitle("Word List Editor")
#if os(iOS)
			.navigationBarTitleDisplayMode(.inline)
#endif
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button(action: { withAnimation { editing.toggle() }}) {
						if editing {
							Image(systemName: "xmark")
						} else {
							Text("Edit")
						}
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button(action: done) {
						Image(systemName: "checkmark")
					}
					.disabled(!editing)
				}
				ToolbarItem {
					ShareLink(item: lwords.url(name: lwords.name))
						.onAppear {
							lwords.save(to: lwords.name)
						}
				}
			}
		}
		.onAppear {
			if let words {
				lwords = words.copy()
				selectedLanguage = lwords.language
				wordList = lwords.placedWords
			}
		}
	}
	
	func done() {
		if let _ = words {
			words!.words = wordList.map(\.word)
			if lwords.name == words!.name {
				words!.name += " Copy"
			} else {
				words!.name = lwords.name
			}
			words!.author = lwords.author
			words!.date = lwords.date
			words!.owner = .user
			words!.save(to: words!.name)  // user words are saved
			lwords = words!.copy()
		}
		editing = false
	}
}

#Preview {
	@Previewable @State var words = SampleWords.list.randomElement()
	NavigationStack {
		WordsEditor(words: $words)
		.environment(DataContainer())
	}
}
