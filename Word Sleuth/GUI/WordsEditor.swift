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
	
//	// MARK: Data (Function) In
//	@Environment(\.dismiss) var dismiss
	
	@State private var lwords = WordList()
	@State private var name = ""
	@State private var wordList = [PlacedWord]()
	@State private var selectedLanguage = Language(rawValue: Locale.current.identifier) ?? .english
	@State private var editWordList = false
	@State private var useFilter = false
	@State private var filter = Filter()
	@State private var importString = ""
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Word List Name") {
					TextField("Word List Name", text: $lwords.name)
						.autocorrectionDisabled(true)
						.showClearButton($lwords.name)
				}
				Section("Author") {
					TextField("Author", text: $lwords.author)
						.autocorrectionDisabled(true)
						.showClearButton($lwords.author)
				}
				Section {
					DatePicker("Date", selection: $lwords.date,
							   displayedComponents: [.date])
				}
				Section {
					Picker("Language", selection: $lwords.language) {
						ForEach(Language.allCases, id: \.self) { language in
							Text(language.description.capitalized).tag(language)
						}
					}
				}
				Section(header:
					VStack(alignment: .leading) {
						Text("Words (\(lwords.words.count)) *Tap List to Edit*")
						Text("**Warning: Importing or pasting deletes existing words!**")
						.font(.caption)
						.foregroundStyle(.red)
					}
				) {
					HStack {
						TextImportButton(name: "Import", text: $importString)

						PasteButton(payloadType: String.self) { strings in
							if let firstText = strings.first {
								importString = firstText
							}
						}
						.buttonBorderShape(.capsule)
						
						Button("Filter...") {
							useFilter.toggle()
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
				ToolbarItem(placement: .confirmationAction) {
					Button(action: done) {
						Image(systemName: "checkmark")
					}
					.disabled(words == lwords)
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
		lwords.words = wordList.map(\.word)
		if lwords.name == words?.name {
			lwords.name += " copy"
		}
		words = lwords  // just point to the new words
		lwords.owner = .user
		lwords.save(to: lwords.name)  // user words are saved
	}
}

#Preview {
	@Previewable @State var words = SampleWords.list.randomElement()
	NavigationStack {
		WordsEditor(words: $words)
		.environment(DataContainer())
	}
}
