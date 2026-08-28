//
//  TimerView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 28.06.2026.
//

import Foundation
import Combine

@Observable class MyTimer {
	var elapsedTime: Int = 0
	var state: TimerState = .stopped
	var endTime: Date?
	
	private var timer: AnyCancellable?
	private var lastTickDate: Date?
	private var accumulatedTimeBeforeCurrentRun: Int = 0
	private var name: String = "timer"
	
	private var fileURL: URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
			.appendingPathComponent(name + ".json")
	}
	
	init(name: String) {
		self.name = name + "_timer"
		loadTimer()
	}
	
	required init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.elapsedTime = try container.decode(Int.self, forKey: .elapsedTime)
		self.state = try container.decode(TimerState.self, forKey: .state)
		self.endTime = try container.decode(Date?.self, forKey: .endTime)
	}
	
	func start() {
		guard state != .running else { return }
		state = .running
		lastTickDate = Date()
		timer = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in self?.update() }
	}
	
	private func update() {
		guard let lastTick = lastTickDate else { return }
		let currentRunDuration = Int(Date().timeIntervalSince(lastTick))
		self.elapsedTime = accumulatedTimeBeforeCurrentRun + currentRunDuration
	}
	
	func pause() {
		guard state == .running else { return }
		update()
		accumulatedTimeBeforeCurrentRun = elapsedTime
		state = .paused
		stopTimerLoop()
	}
	
	func handleViewDisappearing() {
		if state == .running {
			update()
			accumulatedTimeBeforeCurrentRun = elapsedTime
			state = .runningBeforeExit // Flag that it was active when they left
		}
		stopTimerLoop()
		saveToDisk()
	}
	
	func handleViewAppearing() {
		if state == .runningBeforeExit || (state == .stopped && endTime == nil) {
			start()
		}
	}
	
	func stop() {
		state = .stopped
		elapsedTime = 0
		endTime = .now
		accumulatedTimeBeforeCurrentRun = 0
		stopTimerLoop()
		saveToDisk()
	}
	
	private func stopTimerLoop() {
		timer?.cancel()
		timer = nil
		lastTickDate = nil
	}
	
	// MARK: - JSON Disk I/O (Saves only on exit, not every tick)
	private func saveToDisk() {
		if let data = try? JSONEncoder().encode(self) {
			try? data.write(to: fileURL, options: .atomic)
		}
	}
	
	private func loadTimer() {
		guard let data = try? Data(contentsOf: fileURL),
			  let timer = try? JSONDecoder().decode(MyTimer.self, from: data) else { return }
		
		self.elapsedTime = timer.elapsedTime
		self.state = timer.state
		self.endTime = timer.endTime
		self.accumulatedTimeBeforeCurrentRun = self.elapsedTime
	}
}

extension MyTimer: Codable {

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(elapsedTime, forKey: .elapsedTime)
		try container.encode(state, forKey: .state)
		try container.encode(endTime, forKey: .endTime)
	}
	
	enum CodingKeys: String, CodingKey { case elapsedTime, state, endTime }
}

enum TimerState: String, Codable {
	case stopped, running, paused
	case runningBeforeExit // Tracks if the timer needs to auto-resume upon return
}


//struct Timer : Codable {
//
//	var startTime: Date?
//	var endTime: Date?
//	var elapsedTime: TimeInterval = 0
//	var isOver: Bool = false
//	
//	mutating func update() {
//		pause()
//		start()
//	}
//	
//	mutating func start() {
//		if startTime == nil, !isOver {
//			startTime = .now
//			elapsedTime += 0.00001
//		}
//	}
//	
//	mutating func restart() {
//		startTime = .now
//		endTime = nil
//		elapsedTime = 0
//		isOver = false
//	}
//	
//	mutating func stop() {
//		isOver = true
//		endTime = .now
//		pause()
//	}
//	
//	mutating func pause() {
//		if let startTime {
//			elapsedTime += Date.now.timeIntervalSince(startTime)
//		}
//		startTime = nil
//	}
//	
//	enum TimerState: String, Codable {
//		case stopped, running, paused
//		case runningBeforeExit // Tracks if the timer needs to auto-resume upon return
//	}
//	
//}
