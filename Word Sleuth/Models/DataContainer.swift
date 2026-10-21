//
//  GameManager.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 21.08.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

@Observable
@MainActor
class DataContainer {

	var games = [Game]()
	var wordLists = [WordList]()
	var badges = [Badge]()
	var isLandscape = false

	init(loadSampleGames: Bool = false) {
		wordLists = WordList.loadWordLists()
		// print("Word lists is empty, adding init samples...")
		Task.detached(priority: .background) {
			await self.addSampleWords()
		}
		
		if games.isEmpty {
			// load any saved games
			print("Loading games...")
			games = Game.loadGames()
		}
		
		if games.isEmpty || loadSampleGames  {
			print("Adding sample games...")
			addSampleGames()
		}
		
		badges = Badge.loadBadges()
		createBadgesIfNeeded()
	}
	
	static var sample20x20: DataContainer {
		let container = DataContainer()
		container.games = [Game(name: "Sample20x20", 20, cols: 20, words: SampleWords.list[2])]
		return container
	}
	
	private func createBadgesIfNeeded() {
		if badges.isEmpty {
			for details in BadgeDetails.allCases {
				badges.append(Badge(details: details))
			}
			
			Badge.save(badges: badges)
		}
	}
	
	/// Unlock badges based on the Player _bestTimes
	func unlockBadges(newGame: Game, player: Player) {
		let lockedBadges = badges.filter { $0.timestamp == nil }
		let finishedGames = player.gamesPerLevel
		var finishedGamesCount = 0
		var newlyUnlocked: [Badge] = []
		
		func gameCount(for levelRange: ClosedRange<Int>) -> Int {
			var total = 0
			for (level, count) in finishedGames {
				if levelRange.contains(level) {
					total += count
				}
			}
			return total
		}
		
		// total all the games
		for count in finishedGames.values {
			finishedGamesCount += count
		}
		
		// unlock badges
		for badge in lockedBadges {
			switch badge.details {
				case .puzzle1 where finishedGamesCount >= 1,
					 .puzzle3 where finishedGamesCount >= 3 && gameCount(for: 5...10) >= 1,
					 .puzzle5 where finishedGamesCount >= 5 && gameCount(for: 6...10) >= 2,
					 .puzzle7 where finishedGamesCount >= 7 && gameCount(for: 7...10) >= 3,
					 .puzzle10 where finishedGamesCount >= 10 && gameCount(for: 8...10) >= 4,
					 .puzzle20 where finishedGamesCount >= 20 && gameCount(for: 9...10) >= 5,
					 .puzzle30 where finishedGamesCount >= 30 && finishedGames[10] ?? 0 >= 5,
					 .puzzle50 where finishedGamesCount >= 50 && finishedGames[10] ?? 0 >= 10,
					 .puzzle75 where finishedGamesCount >= 75 && finishedGames[10] ?? 0 >= 20,
					 .puzzle100 where finishedGamesCount >= 100 && finishedGames[10] ?? 0 >= 30
						&& lockedBadges.count == 1:
					newlyUnlocked.append(badge)
					print("Unlocked \(badge.details.title)")
				default:
					continue
			}
		}
		
		// add badges to the current game
		for badge in newlyUnlocked {
			newGame.badges.append(badge)
			badge.game = newGame
			badge.timestamp = Date()
			badge.save(to: badge.details.title.key)
		}
	}
	
	/// Returns true if a puzzle with the name "name" exists
	private func puzzleContains(_ name: String) -> Bool {
		games.contains { $0.name == name }
	}
	
	/// Returns true if a puzzle with the name "name" exists
	private func wordListContains(_ name: String) -> Bool {
		wordLists.contains { $0.name == name }
	}
	
	/// Return a unique name with *name* as a basis where *contains* return true if name exists
	private func getUniqueName(name: String, contains: (String) -> Bool) -> String {
		if contains(name) {
			print("Found name \(name)")
			// make a unique name
			var number = 1
			var puzzleName: String { name + "-\(number)" }
			while contains(puzzleName) { number += 1 }
			return puzzleName
		}
		return name
	}
	
	/// Return a unique wordlist name with *name* as a basis
	func getUniqueWordListName(_ name: String) -> String {
		getUniqueName(name: name, contains: wordListContains)
	}
	
	/// Return a unique wordlist name with *name* as a basis
	func getUniquePuzzleName(_ name: String) -> String {
		getUniqueName(name: name, contains: puzzleContains)
	}
	
	@discardableResult
	func createGame(size: Int, words: WordList? = nil) -> Bool {
		let w: WordList
		if let words { w = words }
		else if let words = wordLists.randomElement() { w = words }
		else { w = WordList() }
			
		print("Words = \(w.name), owner = \(w.owner)")
		let game = Game(name: getUniquePuzzleName(w.name), size: size, words: w)
		
		withAnimation {
			self.games.insert(game, at: 0)
		}
		game.save(to: game.name)
		print("Saving game \(game.name)")
		return true
	}
	
	func createGames(number: Int, sizes: [Int], wordlists: [WordList] = []) {
		assert(sizes.count >= number, "Expecting at least \(number) sizes!")
		let noWords = wordlists.isEmpty
		createGame(size: sizes[0], words: noWords ? nil : wordlists[0]) // first one user waits
		Task.detached(priority: .userInitiated) {
			var i = 1
			while i < number {
				if await self.createGame(size: sizes[i], words: noWords ? nil : wordlists[i]) {
					i += 1
				}
			}
		}
	}
	
	func deleteGames(at offsets: IndexSet) {
		for index in offsets {
			let game = games[index]
			print("Deleting game \(game.name)...")
			game.delete()
		}
		
		// Remove from UI array
		games.remove(atOffsets: offsets)
	}
	
	private func addSampleGames() {
		if games.isEmpty {
			let sizes = (0..<10).map { _ in Int.random(in: 8...20) }
			let words = SampleWords.list.shuffled()
			createGames(number: sizes.count, sizes: sizes, wordlists: Array(words[0..<10]))
		}
	}
	
	func addSampleWords() async {
		print("Adding sample words...")
		self.wordLists = SampleWords.list
		print("Successfully loaded without hanging!")
	}
}
