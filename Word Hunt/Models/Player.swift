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
	let id: Int
	
	init(level: Int, interval: TimeInterval) {
		self.level = level
		self.interval = interval
		self.id = level
	}
}

struct Player : Codable {
	var name: String = "Unknown"
	var points: Int = 0
	var bestTimes: [Time] {
		_bestTimes.map { Time(level: $0.key, interval: $0.value)  }
	}
	private var _bestTimes = [Int:TimeInterval]()
	
	mutating func add(points: Int) {
		self.points += points
	}
	
	mutating func updateTimes(level: Int, interval: TimeInterval) {
		if let d = _bestTimes[level] {
			_bestTimes[level] = min(d, interval)
		} else {
			_bestTimes[level] = interval
		}
	}
}
