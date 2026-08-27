//
//  ElapsedTime.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 4/28/25.
//

import SwiftUI

struct ElapsedTime: View {
    // MARK: Data In
	let text: String
	let timer: Timer
    
	@AppStorage(.settings) private var settings

    var body: some View {
		if settings.showTimer {
			HStack {
				if !text.isEmpty { Text(text) }
				if let start = timer.startTime {
					let offset = start - timer.elapsedTime
					if let endTime = timer.endTime {
						Text(.seconds(offset.timeIntervalSince(endTime)), format: format)
					} else {
						if #available(iOS 18.0, *) {
							Text(.durationOffset(to: offset), format: format)
						} else {
							// Fallback on earlier versions
							Text(offset, style: .timer)
						}
					}
				} else {
					Text(.seconds(timer.elapsedTime), format: format)
				}
			}
		}
    }
	
	var format: Duration.TimeFormatStyle {
		if Duration.seconds(timer.elapsedTime) < Duration.seconds(60*60) {
			return .time(pattern: .minuteSecond)
		} else {
			return .time(pattern: .hourMinuteSecond)
		}
	}
}
