//
//  Player.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 13.07.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import Foundation

struct Time: Identifiable {
	let level: Int
	let interval: TimeInterval
	let totalTime: TimeInterval
	let totalWords: Int
	let games: Int
	let words: Int
	var id: Int { level }
	
	init(level: Int, interval: TimeInterval, totalTime: TimeInterval,
		 totalWords: Int, games: Int, words: Int) {
		self.level = level
		self.interval = interval
		self.games = games
		self.words = words
		self.totalTime = totalTime
		self.totalWords = totalWords
	}
}

struct TimeCount: Codable {
	let time: TimeInterval
	let totalTime: TimeInterval
	let totalWords: Int
	let games: Int
	let words: Int
}

struct Player : Codable {
	var name: String = "Unknown"
	var points: Int = 0
	var bestTimes: [Time] {
		_bestTimes.map {
			Time(level: $0.key, interval: $0.value.time,
				 totalTime: $0.value.totalTime, totalWords: $0.value.totalWords,
				 games: $0.value.games, words: $0.value.words)
		}
	}
	private var _bestTimes = [Int:TimeCount]()
	
	var gamesPerLevel: [Int:Int] {
		_bestTimes.mapValues(\.games)
	}
	
	mutating func add(points: Int) {
		self.points += points
	}
	
	mutating func updateTimes(level: Int, interval: TimeInterval, words: Int) {
		guard interval > 0 else { return }
		if let d = _bestTimes[level] {
			_bestTimes[level] = TimeCount(
				time: min(d.time, interval), totalTime: d.totalTime + interval,
				totalWords: d.totalWords + words, games: d.games+1, words: words)
		} else {
			_bestTimes[level] = TimeCount(
				time: interval, totalTime: interval, totalWords: words, games: 1, words: words)
		}
	}
}
