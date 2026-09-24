//
//  MyTimer.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 28.06.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import Foundation

struct Timer: Codable {
	var elapsedTime: Int = 0
	var state: TimerState = .idle
	var lastTickDate: Date? = nil
	
	mutating func start() {
		guard state != .running else { return }
		print("Started...")
		state = .running
		lastTickDate = Date()
	}
	
	private mutating func update() {
		guard let lastTick = lastTickDate else { return }
		print("Updated...")
		let currentRunDuration = Int(Date().timeIntervalSince(lastTick))
		self.elapsedTime += currentRunDuration
	}
	
	mutating func pause() {
		guard state == .running else { return }
		update()
		lastTickDate = Date()
		state = .paused
		print("Paused...")
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

