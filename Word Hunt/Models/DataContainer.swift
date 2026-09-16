//
//  GameManager.swift
//  Word Hunt
//
//  Created by Michael Griebling on 21.08.2026.
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
		if games.isEmpty {
			// load any saved games
			print("Loading games...")
			games = Game.loadGames()
		}
		
		if games.isEmpty || loadSampleGames  {
			print("Adding sample games...")
			addSampleGames()
		}
		
		// wordLists = WordList.loadWordLists()
		print("Word lists is empty, adding init samples...")
		Task.detached(priority: .background) {
			await self.addSampleWords()
		}

		badges = Badge.loadBadges()
		createBadgesIfNeeded()
	}
	
	static var sample20x20: DataContainer {
		let container = DataContainer()
		container.games = [Game(20, cols: 20, words: SampleWords.list[2])]
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
						.puzzle3 where finishedGamesCount >= 3 &&
					gameCount(for: 5...10) >= 1,
						.puzzle5 where finishedGamesCount >= 5 &&
					gameCount(for: 6...10) >= 2,
						.puzzle7 where finishedGamesCount >= 7 &&
					gameCount(for: 7...10) >= 3,
						.puzzle10 where finishedGamesCount >= 10 &&
					gameCount(for: 8...10) >= 4,
						.puzzle20 where finishedGamesCount >= 20 &&
					gameCount(for: 9...10) >= 5,
						.puzzle30 where finishedGamesCount >= 30 &&
					finishedGames[10] ?? 0 >= 5,
						.puzzle50 where finishedGamesCount >= 50 &&
					finishedGames[10] ?? 0 >= 10,
						.puzzle75 where finishedGamesCount >= 75 &&
					finishedGames[10] ?? 0 >= 20,
						.puzzle100 where finishedGamesCount >= 100 &&
					finishedGames[10] ?? 0 >= 30 && lockedBadges.count == 1:
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
			badge.timestamp = newGame.timer.endTime
			badge.save(to: badge.details.title.key)
		}
	}
	
	func createGames(number: Int, sizes: [Int]) {
		assert(sizes.count >= number, "Expecting at least \(number) sizes!")
		let game = Game(size: sizes[0],
						words: SampleWords.list.randomElement()!)
		var names = Set<String>()
		var i = 1
		games.insert(game, at: 0)
		names.insert(game.name)
		game.save(to: game.name)
		print("Saving game \(game.name)")
		Task.detached(priority: .background) {
			while i < number {
				let game = Game(size: sizes[i],
								words: SampleWords.list.randomElement()!)
				if !names.contains(game.name) {
					game.save(to: game.name)
					names.insert(game.name)
					await MainActor.run {
						withAnimation {
							self.games.insert(game, at: 0)
						}
					}
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
			let sizes = (0..<10).map { _ in Int.random(in: 10...20) }
			createGames(number: sizes.count, sizes: sizes)
		}
	}
	
	func addSampleWords() async {
		print("Adding sample words...")
		self.wordLists = SampleWords.list
		
		let randomLists = WordList.loadWordLists()
		if !randomLists.isEmpty {
			self.wordLists.append(contentsOf: randomLists)
			return
		}
		
		// 2. Offload the disk read and decoding to the background (Task.detached or Task)
		// This ensures the main UI thread remains completely untouched and fluid.
		let list = await Task.detached(priority: .background) { () -> [WordList] in
			// This block runs entirely on a background thread
			var list: [WordList] = []
			for i in 3...5 {
				for j in 7...9 {
					print("Building random \(i)-\(j)...")
					let words = WordList(name: "Random \(i)-\(j)", wordRange: i...j, totalWords: 100)
					words.save(to: words.name)
					list.append(words)
				}
			}
			return list
		}.value
		
		self.wordLists.append(contentsOf: list)
		print("Successfully loaded without hanging!")
	}
}
