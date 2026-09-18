//
//  MyTimer.swift
//  Word Hunt
//
//  Created by Michael Griebling on 28.06.2026.
//

import Foundation

struct Timer: Codable {
	var elapsedTime: Int = 0
	var state: TimerState = .idle
	var lastTickDate: Date? = nil
	
	mutating func start() {
		guard state != .running else { return }
		state = .running
		lastTickDate = Date()
	}
	
	private mutating func update() {
		guard let lastTick = lastTickDate else { return }
		let currentRunDuration = Int(Date().timeIntervalSince(lastTick))
		self.elapsedTime += currentRunDuration
	}
	
	mutating func pause() {
		guard state == .running else { return }
		update()
		lastTickDate = Date()
		state = .paused
	}
	
	mutating func handleViewDisappearing() {
		pause()
	}
	
	mutating func handleViewAppearing() {
		start()
	}
	
	mutating func stop() {
		update()
		state = .stopped
	}
}

enum TimerState: String, Codable {
	case idle, stopped, running, paused
}

