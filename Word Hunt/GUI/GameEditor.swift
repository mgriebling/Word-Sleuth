//
//  GameEdiroe.swift
//  Word Hunt
//
//  Created by Michael Griebling on 24.06.2026.
//

import SwiftUI

struct GameEditor: View {
	@Binding var game: Game?
	
	// MARK: Action Function
	let onChoose: () -> Void
	
	@Environment(DataContainer.self) private var dataContainer
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	@AppStorage(.settings) private var settings
	
	// MARK: Internal State
	@State private var lgame = Game(size: 5, words: WordList()) // dummy board
	@State private var selectedWordList = WordList()    // active word list
	@State private var showWordList = false
	@State private var showEmptyAlert = false
	@State private var gameID = UUID()			// forces letter grid updates
	@State private var selectedWord = ""
	
	var words: [WordList] {
		dataContainer.wordLists.sorted { $0.name < $1.name }
	}
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Default Level") {
					Picker("Level:", selection: $settings.level) {
						ForEach(Level.allCases.dropFirst(), id:\.self) { level in
							Text("\(level.rawValue)").tag(level)
						}
					}
					.pickerStyle(.segmented)
					.onChange(of: settings.level, updateGame)
	
				}
				Section("Word List", isExpanded: $showWordList) {
					Picker("Word List Selection:", selection: $selectedWordList) {
						ForEach(words, id:\.self) { Text($0.name) }
					}
					.onChange(of: selectedWordList, updateWords)
								
					WordView(words: lgame.placedWords, style: .paragraph)
				}
				.onTapGesture(perform: toggleWordList)

				Section(header: wordListTitle) {
					LetterGridView(game: lgame, selectedWord: $selectedWord, settings: $settings).id(gameID)
				}
			}
			.onAppear(perform: setUpGame)
			.toolbar {
				EditToolbar() {
					done()
				}
			}
			.navigationTitle(Text("Game Generator"))
			#if os(iOS)
			.navigationBarTitleDisplayMode(.inline)
			#endif
		}
    }
	
	func updateWords() {
		print("Updating words for \(selectedWordList.name)")
		withAnimation {
			print("Selected word list: \(selectedWordList.words)")
			updateGame()
		}
	}
	
	func setUpGame() {
		if let game {
			lgame = game.copy()
			updateGame()
		}
	}
	
	func toggleWordList() { withAnimation { showWordList.toggle() }	}
	
	func done() {
		if lgame.board.words.words.isEmpty {
			showEmptyAlert = true
			return
		}
		game = lgame.copy()
		onChoose()
		dismiss()
	}
	
	private var wordListTitle: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack {
				Text("Game Board Layout")
				Button("Update") { withAnimation { updateGame() } }
			}
			let missing = lgame.board.missingWords
			if !missing.isEmpty {
				Text("Missing \(missing.count): \(missing.joined(separator: ", "))")
					.lineLimit(1)
					.font(.caption)
			}
		}
	}
	
	func updateGame() {
		print("Grid size: \(settings.level.size)")
		print("Updating game with \(selectedWordList.words.count) words")
		lgame = Game(size: settings.level.size, words: selectedWordList)
		gameID = UUID()
		print("Finished game update")
	}
}

#Preview {
	@Previewable
	@State var game: Game? = Game(size: 12, words: SampleWordLists.all[1])
	GameEditor(game: $game) {
		print("Updated game")
	}
	.environment(DataContainer())
}
