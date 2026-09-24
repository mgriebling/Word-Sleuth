//
//  ElapsedTime.swift
//  Word Sleuth
//
//  Created by CS193p Instructor on 4/28/25.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct ElapsedTime: View {
    // MARK: Data In
	let text: String
	let timer: Timer
    
	var body: some View {
		HStack {
			if !text.isEmpty { Text(text) }
			if let tickDate = timer.lastTickDate, timer.state == .running {
				let newTime = tickDate.addingTimeInterval(-TimeInterval(timer.elapsedTime))
				Text(newTime, style: .timer)
			} else {
				Text(formatTime(timer.elapsedTime))
			}
		}
	}
	
	private func formatTime(_ totalSeconds: Int) -> String {
		let secondsPerMinute = 60
		let minutesPerHour = 60
		let secondsPerHour = minutesPerHour * secondsPerMinute
		let hours = totalSeconds / secondsPerHour
		let minutes = (totalSeconds % secondsPerHour) / secondsPerMinute
		let seconds = totalSeconds % secondsPerMinute
		if hours > 0 {
			return String(format: "%d:%02d:%02d", hours, minutes, seconds)
		} else {
			return String(format: "%d:%02d", minutes, seconds)
		}
	}
}
