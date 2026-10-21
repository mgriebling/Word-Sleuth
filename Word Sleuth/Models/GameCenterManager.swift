//
//  GameCenterManager.swift
//  Word Sleuth
//
//  Created by Google AI on 21.10.2026.
//

import GameKit
import SwiftUI

@MainActor
class GameCenterManager: NSObject, ObservableObject {
	@Published var isAuthenticated = false
	@Published var authViewController: UIViewController?
	
	// Cache current achievements locally to avoid duplicate network calls
	private var reportedAchievements: [GKAchievement] = []
	
	func authenticatePlayer() {
		let localPlayer = GKLocalPlayer.local
		
		localPlayer.authenticateHandler = { [weak self] viewController, error in
			guard let self = self else { return }
			
			if let viewController = viewController {
				self.authViewController = viewController
			} else if localPlayer.isAuthenticated {
				self.isAuthenticated = true
				// Pre-load achievements cache immediately upon login
				Task { await self.loadExistingAchievements() }
			} else {
				self.isAuthenticated = false
			}
		}
	}
	
	// MARK: - LEADERBOARDS
	/// Submits a fresh score to an active App Store Connect Leaderboard ID.
	func submitHighScore(score: Int, leaderboardID: String) async {
		guard isAuthenticated else { return }
		
		do {
			// Context is an optional 64-bit integer metadata flag (0 is standard)
			try await GKLeaderboard.submitScore(
				score,
				context: 0,
				player: GKLocalPlayer.local,
				leaderboardIDs: [leaderboardID]
			)
			print("Successfully submitted score of \(score) to \(leaderboardID)")
		} catch {
			print("Failed to submit score: \(error.localizedDescription)")
		}
	}
	
	// MARK: - ACHIEVEMENTS
	/// Loads achievements from Apple servers to check current progress thresholds
	private func loadExistingAchievements() async {
		do {
			self.reportedAchievements = try await GKAchievement.loadAchievements()
		} catch {
			print("Error loading achievement cache: \(error.localizedDescription)")
		}
	}
	
	/// Reports an achievement update.
	/// - Parameters:
	///   - identifier: The exact ID string from App Store Connect.
	///   - percent: Double value ranging from 0.0 to 100.0.
	func reportAchievement(identifier: String, percent: Double) async {
		guard isAuthenticated else { return }
		
		// Clamp bounds securely between 0 and 100%
		let progress = max(0.0, min(percent, 100.0))
		
		// Use cached progress if available, otherwise initialize a clean object instance
		let achievement = reportedAchievements.first(where: { $0.identifier == identifier })
						  ?? GKAchievement(identifier: identifier)
		
		// Exit early if the player has already achieved this score to conserve bandwidth
		if achievement.isCompleted && progress >= 100.0 { return }
		if progress <= achievement.percentComplete { return }
		
		achievement.percentComplete = progress
		// Triggers the native drop-down Apple notification toast upon 100% completion
		achievement.showsCompletionBanner = true
		
		do {
			try await GKAchievement.report([achievement])
			
			// Sync with local array storage
			if let index = reportedAchievements.firstIndex(where: { $0.identifier == identifier }) {
				reportedAchievements[index] = achievement
			} else {
				reportedAchievements.append(achievement)
			}
			print("Achievement \(identifier) updated to \(progress)%")
		} catch {
			print("Failed reporting achievement: \(error.localizedDescription)")
		}
	}
}


