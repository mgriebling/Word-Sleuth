//
//  AchievementsView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 13.07.2026.
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
		VStack(alignment: .leading) {
			header("Earned Points: \(settings.player.points)")
			Text("Earn points for each completed puzzle with one point for each word. Five points are lost for each **hint \(Image(systemName: "lightbulb"))** button use. Compete with friends to see who has the most points!")
				.font(.caption)
			
//			let bestTimes =
//			[Time(level: 10, interval: 1000, games: 3, words: 50),
//			 Time(level: 3, interval: 300, games: 5, words: 20),
//			 Time(level: 1, interval: 500, games: 10, words: 5)]
			
			if !settings.player.bestTimes.isEmpty {
				header("Puzzle Statistics")
				let s = settings.player.bestTimes
				Grid(alignment: .center, horizontalSpacing: 20, verticalSpacing: 8) {
					GridRow {
						Text("Level").bold()
						Text("Best Time").bold()
						Text("Time/Word").bold()
						Text("Games").bold()
					}
					.foregroundStyle(.secondary)
					Divider()
					
					// Data Rows
					ForEach(s.sorted{ $0.level < $1.level }) { item in
						GridRow(alignment: .center) {
							Text(item.level, format: .number) //      "\(item.level)")
							Text(Duration.seconds(item.interval), format: .time(pattern: .hourMinuteSecond))
							Text("\(Int(item.interval) / item.words) secs")
							Text(item.games, format: .number)  // "\(item.games)")
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
						}
					}
				}
				.scrollClipDisabled(true)
				.scrollIndicators(.hidden)
			}
			
			if !lockedBadges.isEmpty {
				header("Locked Badges")
				ForEach(sortedLockedBadges) { badge in
					LockedAwardView(badge: badge)
				}
			}
		}
		
		.padding()
		.frame(maxWidth: .infinity)
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
