//
//  BadgeDetails.swift
//  GratefulMoments
//
//  Created by Michael Griebling on 08.07.2026.
//

import SwiftUI

enum BadgeDetails: Int, Codable, CaseIterable {
	case puzzle1
	case puzzle3
	case puzzle5
	case puzzle7
	case puzzle10
	case puzzle20
	case puzzle30
	case puzzle50
	case puzzle75
	case puzzle100
	
	var requirements: String {
		switch self {
			case .puzzle1:
				"Solve a puzzle to unlock this award."
			case .puzzle3:
				"Complete three puzzles with to earn this badge. Earlier solved puzzles count as well. At least one should be level 5 or higher."
			case .puzzle5:
				"Work out five puzzles to earn this badge. At least two need to be level 6 or higher."
			case .puzzle7:
				"Unravel seven puzzles to earn this badge. A minimum of three need to be at level 7 or higher."
			case .puzzle10:
				"Crack ten puzzles to earn this badge. Four need to be at difficulty level 8 or higher."
			case .puzzle20:
				"Decipher twenty puzzles for this badge. At least five need to be at level 9 or higher."
			case .puzzle30:
				"Out of thirty puzzles for this badge, you'll at least five puzzles rated at level 10."
			case .puzzle50:
				"The magic number is 50 puzzles. Ten or more puzzles must be rated at level 10."
			case .puzzle75:
				"Solve a total of 75 puzzles. A minimum of 20 puzzles must be rated at level 10."
			case .puzzle100:
				"Successfully complete 100 puzzles and have all nine earlier badges. At least 30 puzzles must be at level 10."
		}
	}
	
	var congratulatoryMessage: String {
		switch self {
			case .puzzle1:
				"Every journey begins with a single step. Congratulations — you’re on your way!"
			case .puzzle3:
				"You’re building momentum! The more you focus on regular practice, the better you get at choosing to keep up your intentioned habits."
			case .puzzle5:
				"Puzzles are a great way to invigorate your brain and keep your mind active. You're doing amazing work!"
			case .puzzle7:
				"Finding a word in a word search puzzle is like finding a needle in a haystack — but one that you know is there, just waiting to be discovered."
			case .puzzle10:
				"Look at you, improving yourself by solving all of these puzzles!"
			case .puzzle20:
				"For me, the most enjoyable part is the puzzle, the process of solving, not the solution itself. — Ernő Rubik"
			case .puzzle30:
				"Willingness to be puzzled is a valuable trait to cultivate, from childhood to advanced inquiry. — Noam Chomsky"
			case .puzzle50:
				"Exercising the mind is as important as exercise for the body. Keep up the great work!"
			case .puzzle75:
				"You're almost there. Persistance is key to achieving your goal. You've made amazing progress!"
			case .puzzle100:
				"You've unlocked the full potential of your puzzle solving practice. But don't stop now - keep going!"
		}
	}
	
	var title: String {
		switch self {
			case .puzzle1:   "Start the Journey"
			case .puzzle3:   "A Hat Trick"
			case .puzzle5:   "5 Stars"
			case .puzzle7:   "On a Streak"
			case .puzzle10:  "Perfect 10"
			case .puzzle20:  "Roaring Twenties"
			case .puzzle30:  "Amazing Achievement"
			case .puzzle50:  "Savant"
			case .puzzle75:  "Master"
			case .puzzle100: "Grand Master"
		}
	}
	
	var image: ImageResource {
		switch self {
			case .puzzle1: .puzzle1
			case .puzzle3: .puzzle3
			case .puzzle5: .puzzle5
			case .puzzle7: .puzzle7
			case .puzzle10: .puzzle10
			case .puzzle20: .puzzle20
			case .puzzle30: .puzzle30
			case .puzzle50: .puzzle50
			case .puzzle75: .puzzle75
			case .puzzle100: .puzzle100
		}
	}
	
	var color: Color {
		switch self {
			case .puzzle1:   Color(.darkBlue)
			case .puzzle3:   Color(.classicBurgandy)
			case .puzzle5:   Color(.matteBlack)
			case .puzzle7:   Color(.emeraldGreen)
			case .puzzle10:  Color(.darkBlue)
			case .puzzle20:  Color(.crimsonRed)
			case .puzzle30:  Color(.deepTeal)
			case .puzzle50:  Color(.matteBlack)
			case .puzzle75:  Color(.matteBlack)
			case .puzzle100: Color(.matteBlack)
		}
	}
}
