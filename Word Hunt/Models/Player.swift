//
//  Player.swift
//  Word Hunt
//
//  Created by Michael Griebling on 13.07.2026.
//

import Foundation

struct Player : Codable {
	var name: String = "Unknown"
	var points: Int = 0
	var bestTimes = [Difficulty:Duration]()
	
	mutating func add(points: Int) {
		self.points += points
	}
	
	mutating func updateTimes(level: Difficulty, duration: Duration) {
		if let d = bestTimes[level] {
			bestTimes[level] = min(d, duration)
		} else {
			bestTimes[level] = duration
		}
	}
}
