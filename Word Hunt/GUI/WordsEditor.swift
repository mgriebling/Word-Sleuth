//
//  WordsEditor.swift
//  Word Hunt
//
//  Created by Michael Griebling on 22.06.2026.
//

import SwiftUI

struct WordsEditor: View {
	@Binding var words: WordList?
	var onDone: (() -> Void)?
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	@State private var lwords: WordList = WordList()
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
					Picker("Language", selection: $selectedLanguage) {
						ForEach(Language.allCases, id: \.self) {
							Text($0.description.capitalized)
						}
					}
					.onSubmit {
						lwords.language = selectedLanguage
						print("Chose: \(selectedLanguage.description)")
					}
				}
				Section(header:
					VStack(alignment: .leading) {
						Text("Words (\(lwords.words.count)) *Tap List to Edit*")
						Text("**Warning: Importing or pasting deletes existing words!**")
						.font(.caption)
					}
				) {
					HStack {
						TextImportButton(name: "Import Text", text: $importString)

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
					if onDone == nil {
						// update passed to word list directly
						words = lwords
					}
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
				if onDone != nil {
					EditToolbar() { done() }
				}
			}
		}
		.onAppear {
			if let words {
				lwords = words
				selectedLanguage = lwords.language
				wordList = lwords.placedWords
			}
		}
	}
	
	func done() {
		lwords.words = wordList.map(\.word)
		words = lwords
		onDone?()
		dismiss()
	}
}

#Preview {
	@Previewable @State var words = SampleWords.list.randomElement()
	NavigationStack {
		WordsEditor(words: $words) {
			// nothing to do
		}
		.environment(DataContainer())
	}
}
