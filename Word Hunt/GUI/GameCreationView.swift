//
//  GameCreationView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 19.07.2026.
//

import SwiftUI

struct GameCreationView: View {
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var numberOfGames = 1
	@State private var wordListOption = 1
	@State private var size = -2
	@State private var sizes = [Int]()
	@State private var minSize = Int(SettingsType.maxColRange.lowerBound)
	@State private var maxSize = Int(SettingsType.maxColRange.upperBound)
	@State private var sizeToAdd: Int?
	@State private var level = Level.five
	@State private var prevLevel = Level.five
	@State private var wordList: WordList?
	@State private var wordListsToUse = [WordList]()
	@State private var creationMode = CreationMode.oneGame
	@State private var showSize = false
	@State private var showWordList = false
	
	var body: some View {
		let sortedWordList = dataContainer.wordLists.sorted { $0.name < $1.name }
		NavigationStack {
			Form {
				Section("Number of Puzzles to Create") {
					Picker("Create Puzzle:", selection: $creationMode.animation()) {
						ForEach(CreationMode.allCases.dropLast(), id:\.self) { mode in
							Text(mode.localized).tag(mode)
						}
						Image(systemName: "ellipsis")
							.tag(CreationMode.custom)
					}
					.onChange(of: creationMode) {
						if creationMode != .custom {
							numberOfGames = creationMode.number
						} else {
							numberOfGames = 6
						}
					}
					.pickerStyle(.segmented)
					
					if creationMode == .custom {
						HStack {
							Text("Puzzles: \(numberOfGames) ")
							Slider(value: Binding(
								get: { Double(numberOfGames) },
								set: { numberOfGames = Int($0) }
							), in: 6...20)
						}
					}
				}
	
				Section("Puzzle Level") {
					Picker("Level:", selection: $level) {
						ForEach(Level.allCases, id:\.self) { level in
							Text(level.localized).tag(level)
						}
					}
					.pickerStyle(.segmented)
					.onChange(of: level) { prev, newValue in
						prevLevel = prev
						showSize = level == .manual
					}
				}
				
				let puzzleTitle = "Puzzle Size" + (level == .manual ? "" : " (" + puzzleSize(size: level.size) + ")")

				Section(puzzleTitle, isExpanded: $showSize) {
					Picker("Choose size:", selection: $size) {
						Text("Random").tag(0)
						Text("Random in range").tag(-1)
						Text("Selected Sizes").tag(-2)
						ForEach(SettingsType.maxRowRange, id:\.self) { index in
							Text(puzzleSize(size: index)).tag(index)
						}
					}
					.onAppear {
						size = prevLevel.size
					}
					if size == -1 {
						Stepper("Min: " + puzzleSize(size:minSize), value: $minSize, in: SettingsType.maxRowRange)
						Stepper("Max: " + puzzleSize(size:maxSize), value: $maxSize, in: SettingsType.maxRowRange)
					} else if size == -2 {
						Picker("Size:", selection: $sizeToAdd) {
							ForEach(SettingsType.maxRowRange, id:\.self) { index in
								Text(puzzleSize(size:index)).tag(index)
							}
						}
						.onChange(of: sizeToAdd) {
							if let size = sizeToAdd {
								sizes.append(size)
							}
						}
						List(sizes, id: \.self) { size in
							Text(puzzleSize(size:size))
						}
					}
				}
				.onTapGesture {
					showSize.toggle()
					if showSize { level = .manual }
					else { level = prevLevel }
				}
		
				Section("Word List to Use", isExpanded: $showWordList) {
					Picker("Word List to Use:", selection: $wordListOption) {
						Text("Random").tag(1)
						Text("Selected").tag(2)
					}
					.pickerStyle(.segmented)
					if wordListOption == 2 {
						Picker("Choose:", selection: $wordList) {
							ForEach(sortedWordList) { list in
								Text(list.name).tag(list)
							}
						}
						.onChange(of: wordList) {
							if let words = wordList {
								wordListsToUse.append(words)
							}
						}
						
						List(wordListsToUse, id: \.self) { list in
							Text(list.name)
						}
					}
				}
				.onTapGesture {
					showWordList.toggle()
					if !showWordList { wordListOption = 1 }
				}
			}
			.toolbar {
				EditToolbar(onDone: createGames)
			}
			.navigationTitle("Advanced Game Generator")
			.navigationBarTitleDisplayMode(.inline)
		}
    }
	
	private func puzzleSize(size: Int = 0) -> String {
		let rows = size == 0 ? level.size : size
		let cols = UIDevice.current.userInterfaceIdiom == .phone ? min(12, rows) : rows
		return "\(rows) ⨉ \(cols)"
	}
	
	private func createGames() {
		if level != .manual {
			sizes = Array(repeating: level.size, count: numberOfGames)
			wordListOption = 1
		}
		if size == 0 || size == -1 {
			for _ in 0..<numberOfGames {
				sizes.append(Int.random(in: minSize...maxSize))
			}
		}
		while sizes.count < numberOfGames {
			sizes.append(contentsOf: sizes)
		}
		if wordListOption == 1 {
			for _ in 0..<numberOfGames {
				wordListsToUse.append(dataContainer.wordLists.randomElement()!)
			}
		}
		while wordListsToUse.count < numberOfGames {
			wordListsToUse.append(contentsOf: wordListsToUse)
		}
		
		// generate games in the background
		Task.detached(priority: .background) {
			var numberOfGames = await self.numberOfGames
			var sizes = await self.sizes
			var wordListsToUse = await self.wordListsToUse
			let level = await self.level
			while numberOfGames > 0 {
				print("Generating game...")
				let game = Game(size: sizes[0], words: wordListsToUse[0])
				if level == .manual || game.level == level.value {
					await MainActor.run {
						print("Adding game \(game.name)")
						dataContainer.games.insert(game, at: 0)
					}
					sizes.removeFirst()
					wordListsToUse.removeFirst()
					numberOfGames -= 1
				}
			}
		}
	}
}

#Preview {
	GameCreationView()
		.environment(DataContainer())
}
