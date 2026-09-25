//
//  AchievementsView.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 13.07.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct AchievementsView: View {
	
	@State private var unlockedBadges: [Badge] = []
	@State private var lockedBadges: [Badge] = []
	
	@Environment(DataContainer.self) private var dataContainer
	
	// MARK: Data (Function) In/Out
	@AppStorage(.settings) private var settings
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack {
			ScrollView {
				contentStack
			}
			.onAppear() {
				unlockedBadges = dataContainer.badges.filter{ $0.timestamp != nil }
				lockedBadges = dataContainer.badges.filter{ $0.timestamp == nil }
			}
			.navigationTitle("Achievements")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(action: { dismiss() }) {
						Image(systemName: "xmark")
					}
				}
			}
		}
		.dynamicTypeSize(...DynamicTypeSize.xxxLarge)
	}
	
	private var contentStack: some View {
		VStack(alignment: .leading, spacing: 0) {
			let points = settings.player.points
			let earned = PointDetails(points: points)
			header("Earned Points: \(points)")
			Self.tierLevel(points: earned)
			Text("Earn points for each completed puzzle with one point for each word. Five points are lost for each **hint \(Image(systemName: "lightbulb"))** button use. A new tier, each with three levels, is unlocked every 100 points. Compete with friends to see who has the most points, medallions, and highest tier level!")
				.font(.caption)
			if !settings.player.bestTimes.isEmpty {
				header("Puzzle Statistics")
				let s = settings.player.bestTimes
				let total = s.reduce(0) { $0 + $1.games }
				Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 8) {
					GridRow {
						Text("Level").bold()
						Text("Best Time").bold()
						Text("Time/Word").bold()
						Text("Puzzles (\(total))").bold()
					}
					.foregroundStyle(.secondary)
					Divider()
					
					// Data Rows
					ForEach(s.sorted{ $0.level < $1.level }) { item in
						GridRow(alignment: .center) {
							Text(item.level, format: .number)
							Text(Duration.seconds(item.interval), format: .time(pattern: .hourMinuteSecond))
							Text("\(Int(item.interval) / item.words) secs")
							Text(item.games, format: .number)
						}
					}
				}
			}

			if !unlockedBadges.isEmpty {
				header("Your Earned Badges")
				ScrollView(.horizontal) {
					HStack {
						ForEach(sortedUnlockedBadges) { badge in
							UnlockedAwardView(badge: badge)
								.frame(maxHeight: .infinity)
						}
					}
					.fixedSize(horizontal: false, vertical: true)
				}
				.scrollClipDisabled(true)
				.scrollIndicators(.hidden)
			}
			
			if !lockedBadges.isEmpty {
				header("Locked Badges")
				ForEach(sortedLockedBadges) { badge in
					LockedAwardView(badge: badge)
						.padding(.vertical, 5)
				}
			}
		}
		
		.padding()
		.frame(maxWidth: .infinity)
	}
	
	@ViewBuilder
	static func tierLevel(points: PointDetails) -> some View {
		if !points.isEmpty {
			VStack(alignment: .center, spacing: 0) {
				Text("\(points.title) Level \(points.count)")
					.font(.title2).bold()
				HStack(alignment: .top) {
					ForEach(0..<points.count, id: \.self) { _ in
						Image(points.image)
							.resizable()
							.aspectRatio(contentMode: .fit)
					}
				}
			}
			.frame(maxWidth: .infinity)
			.frame(height: 100)
		}
	}
	
	func header(_ text: String) -> some View {
		Text(text)
			.font(.headline.bold())
			.padding(.top)
			.padding(.bottom, 3)
	}
	
	private var sortedUnlockedBadges: [Badge] {
		unlockedBadges.sorted {
			$0.details.rawValue < $1.details.rawValue
		}
	}
	
	private var sortedLockedBadges: [Badge] {
		lockedBadges.sorted {
			$0.details.rawValue < $1.details.rawValue
		}
	}
}

#Preview {
	AchievementsView()
		.environment(DataContainer())
}
