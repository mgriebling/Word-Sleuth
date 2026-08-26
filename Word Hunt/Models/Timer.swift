//
//  TimerView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 28.06.2026.
//

import Foundation

struct Timer : Codable {
	
	var startTime: Date?
	var endTime: Date?
	var elapsedTime: TimeInterval = 0
	var lastAttemptDate: Date? = Date.now
	var isOver: Bool = false
	
	mutating func update() {
		pause()
		start()
	}
	
	mutating func start() {
		if startTime == nil, !isOver {
			startTime = .now
			elapsedTime += 0.00001
		}
	}
	
	mutating func restart() {
		startTime = .now
		endTime = nil
		elapsedTime = 0
		isOver = false
	}
	
	mutating func stop() {
		isOver = true
		endTime = .now
		pause()
	}
	
	mutating func pause() {
		if let startTime {
			elapsedTime += Date.now.timeIntervalSince(startTime)
		}
		startTime = nil
	}
	
}
