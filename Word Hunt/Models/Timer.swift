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
	
	init() {
		self.elapsedTime = 0
		self.state = .stopped
		self.endTime = nil
		self.name = "_timer"
	}
	
	convenience init(name: String) {
		self.init()
		self.name = name + "_timer"
	}
	
	required init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.elapsedTime = try container.decode(Int.self, forKey: .elapsedTime)
		self.state = try container.decode(TimerState.self, forKey: .state)
		self.endTime = try container.decode(Date?.self, forKey: .endTime)
		self.name = try container.decode(String.self, forKey: .name)
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
		//print("Timer \(name) paused")
		update()
		accumulatedTimeBeforeCurrentRun = elapsedTime
		state = .paused
		stopTimerLoop()
	}
	
	func handleViewDisappearing() {
//		print("\(name) disappearing")
		if state == .running {
			update()
			accumulatedTimeBeforeCurrentRun = elapsedTime
			state = .runningBeforeExit // Flag that it was active when they left
		}
		stopTimerLoop()
		saveToDisk()
	}
	
	func handleViewAppearing() {
//		print("\(name) appearing")
		if state == .runningBeforeExit || (state == .stopped && endTime == nil) {
			start()
		}
	}
	
	func stop() {
		//print("Timer \(name) stopped")
		state = .stopped
		// elapsedTime = 0
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
//			print("Saved \(name), state = \(state)")
			try? data.write(to: fileURL, options: .atomic)
		}
	}
	
	private func loadTimer() {
		guard let data = try? Data(contentsOf: fileURL),
			  let timer = try? JSONDecoder().decode(MyTimer.self, from: data) else { return }
//		print("Loaded \(name), state = \(state)")
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
		try container.encode(name, forKey: .name)
	}
	
	enum CodingKeys: String, CodingKey { case elapsedTime, state, endTime, name }
}

enum TimerState: String, Codable {
	case stopped, running, paused
	case runningBeforeExit // Tracks if the timer needs to auto-resume upon return
}

