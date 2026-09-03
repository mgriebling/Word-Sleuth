//
//  Player.swift
//  Word Hunt
//
//  Created by Michael Griebling on 13.07.2026.
//

import Foundation

struct Time: Identifiable {
	let level: Int
	let interval: TimeInterval
	let games: Int
	let words: Int
	var id: Int { level }
	
	init(level: Int, interval: TimeInterval, games: Int, words: Int) {
		self.level = level
		self.interval = interval
		self.games = games
		self.words = words
	}
}

struct TimeCount: Codable {
	let time: TimeInterval
	let games: Int
	let words: Int
}

struct Player : Codable {
	var name: String = "Unknown"
	var points: Int = 0
	var bestTimes: [Time] {
		_bestTimes.map {
			Time(level: $0.key, interval: $0.value.time, games: $0.value.games, words: $0.value.words)
		}
	}
	private var _bestTimes = [Int:TimeCount]()
	
	mutating func add(points: Int) {
		self.points += points
	}
	
	mutating func updateTimes(level: Int, interval: TimeInterval, words: Int) {
		guard interval > 0 else { return }
		if let d = _bestTimes[level] {
			if d.time == 0 {
				// correct erroneous 0 times
				_bestTimes[level] = TimeCount(time: interval, games: d.games+1, words: words)
			} else {
				_bestTimes[level] = TimeCount(time: min(d.time, interval), games: d.games+1, words: words)
			}
		} else {
			_bestTimes[level] = TimeCount(time: interval, games: 1, words: words)
		}
	}
}
