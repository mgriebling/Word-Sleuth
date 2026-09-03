//
//  GameManager.swift
//  Word Hunt
//
//  Created by Michael Griebling on 21.08.2026.
//

import Foundation
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
			games = Game.loadGames()
		}
		
		if loadSampleGames {
			addSampleGames()
		}
		
		wordLists = WordList.loadWordLists()
		if wordLists.isEmpty {
			addSampleWords()
		}
		
		Task.detached(priority: .background) {
			await WordList.save(wordLists: self.wordLists)
		}
		
		badges = Badge.loadBadges()
		createBadgesIfNeeded()
	}
	
	static var sample20x20: DataContainer {
		let container = DataContainer()
		container.games = [Game(20, cols: 20, words: SampleWordLists.all[2])]
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
	
	func unlockBadges(newGame: Game) {
		let lockedBadges = badges.filter { $0.timestamp == nil }
		let finishedGames = games.filter { $0.isOver }
		var newlyUnlocked: [Badge] = []
		for badge in lockedBadges {
			switch badge.details {
				case .puzzle1 where finishedGames.count >= 1,
					 .puzzle3 where finishedGames.count >= 3 &&
					finishedGames.count(where: {$0.level >= 5}) >= 1,
					 .puzzle5 where finishedGames.count >= 5 &&
					finishedGames.count(where: {$0.level >= 6}) >= 2,
					 .puzzle7 where finishedGames.count >= 7 &&
						finishedGames.count(where: {$0.level >= 7}) >= 3,
					 .puzzle10 where finishedGames.count >= 10 &&
						finishedGames.count(where: {$0.level >= 8}) >= 4,
					 .puzzle20 where finishedGames.count >= 20 &&
						finishedGames.count(where: {$0.level >= 9}) >= 5,
					 .puzzle30 where finishedGames.count >= 30 &&
						finishedGames.count(where: {$0.level == 10}) >= 5,
					 .puzzle50 where finishedGames.count >= 50 &&
						finishedGames.count(where: {$0.level == 10}) >= 10,
					 .puzzle75 where finishedGames.count >= 75 &&
						finishedGames.count(where: {$0.level == 10}) >= 20,
					 .puzzle100 where finishedGames.count >= 100 &&
						lockedBadges.count == 1 &&
						finishedGames.count(where: {$0.level == 10}) >= 30:
					newlyUnlocked.append(badge)
					print("Unlocked \(badge.details.title)")
				default:
					continue
			}
		}
		for badge in newlyUnlocked {
			newGame.badges.append(badge)
			badge.game = newGame
			badge.timestamp = newGame.timer.endTime
			badge.save(to: badge.details.title)
		}
	}
	
	func createGames(number: Int, sizes: [Int]) {
		assert(sizes.count >= number, "Expecting at least \(number) sizes!")
		let game = Game(size: sizes[0],
						words: SampleWordLists.all.randomElement()!)
//		print("Generating game...")
		self.games.insert(game, at: 0)
		game.save(to: game.name)
		Task.detached(priority: .background) {
			for i in 1..<number {
//				print("Generating game...")
				let game = Game(size: sizes[i],
								words: SampleWordLists.all.randomElement()!)
				game.save(to: game.name)
				await MainActor.run {
					withAnimation {
						self.games.insert(game, at: 0)
					}
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
			createGames(number: 10, sizes: sizes)
		}
	}
	
	private func addSampleWords() {
		if wordLists.isEmpty {
			wordLists = SampleWordLists.all
		}
	}
	
}
