//
//  GameCreationView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 19.07.2026.
//

import SwiftUI

struct GameCreationView: View {
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var numberOfGames = 6
	@State private var wordListOption = 2
	@State private var size = -2
	@State private var sizes = [Int]()
	@State private var minSize = Int(SettingsType.maxColRange.lowerBound)
	@State private var maxSize = Int(SettingsType.maxColRange.upperBound)
	@State private var sizeToAdd: Int?
	@State private var level: Difficulty = .manual
	@State private var wordList: WordList?
	@State private var wordListsToUse = [WordList]()
	@State private var creationMode = CreationMode.custom
	
    var body: some View {
		NavigationStack {
			Form {
				Section("Number of Puzzles to Create") {
					Picker("Create Game:", selection: $creationMode.animation()) {
						ForEach(CreationMode.allCases.dropLast(), id:\.self) { mode in
							Text("\(mode.rawValue)").tag(mode)
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
							Text("Games: \(numberOfGames) ")
							Slider(value: Binding(
								get: { Double(numberOfGames) },
								set: { numberOfGames = Int($0) }
							), in: 6...20)
						}
					}
				}
	
				Section("Puzzle Level") {
					Picker("Difficulty:", selection: $level) {
						ForEach(Difficulty.allCases, id:\.self) { level in
							Text("\(level.rawValue)").tag(level)
						}
					}
					.pickerStyle(.segmented)
				}
				if level == .manual {
					Section("Puzzle Size") {
						Picker("Choose size:", selection: $size) {
							Text("Random").tag(0)
							Text("Random in range").tag(-1)
							Text("Selected Sizes").tag(-2)
							ForEach(SettingsType.maxRowRange, id:\.self) { index in
								Text(puzzleSize(size: index)).tag(index)
							}
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
					Section("Word List to Use") {
						Picker("Word List to Use:", selection: $wordListOption) {
							Text("Random").tag(1)
							Text("Selected").tag(2)
						}
						.pickerStyle(.segmented)
						if wordListOption == 2 {
							Picker("Choose:", selection: $wordList) {
								ForEach(dataContainer.wordLists) { list in
									Text("\(list.name)").tag(list)
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
				}
			}
			.toolbar {
				EditToolbar(onDone: createGames)
			}
			.navigationTitle(Text("Advanced Game Generator"))
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
