//
//  PointDetails.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 16.09.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

enum PointDetails: Codable {
	case topaz(Int), citrine(Int), amethyst(Int), aquamarine(Int), pearl(Int)
	case diamond(Int), ruby(Int), sapphire(Int), emerald(Int), blueDiamond(Int)
	case empty
	
	var title: LocalizedStringResource {
		switch self {
			case .topaz: "Topaz Tier"
			case .citrine: "Citrine Tier"
			case .amethyst: "Amethyst Tier"
			case .aquamarine: "Aquamarine Tier"
			case .pearl: "Pearl Tier"
			case .diamond: "Diamond Tier"
			case .ruby: "Ruby Tier"
			case .sapphire: "Sapphire Tier"
			case .emerald: "Emerald Tier"
			case .blueDiamond: "Blue Diamond Tier"
			default: ""
		}
	}
	
	var isEmpty: Bool {
		switch self {
			case .empty: true
			default: false
		}
	}
	
	var count: Int {
		switch self {
			case .topaz(let n): n
			case .citrine(let n): n
			case .amethyst(let n): n
			case .aquamarine(let n): n
			case .pearl(let n): n
			case .diamond(let n): n
			case .ruby(let n): n
			case .sapphire(let n): n
			case .emerald(let n): n
			case .blueDiamond(let n): n
			default: 0
		}
	}
	
	var image: ImageResource {
		switch self {
			case .topaz: .topaz
			case .citrine: .citrine
			case .amethyst: .amethyst
			case .aquamarine: .aquamarine
			case .pearl: .pearl
			case .diamond: .diamond
			case .ruby: .ruby
			case .sapphire: .sapphire
			case .emerald: .emerald
			case .blueDiamond: .blueDiamond
			default: .coal
		}
	}
	
	/// Added five levels to each tier to go to 5000 points
	init(points: Int) {
		switch points {
			case 100...599:   self = .topaz(points / 100)
			case 600...1099:  self = .citrine((points - 500) / 100)
			case 1100...1599: self = .amethyst((points - 1000) / 100)
			case 1600...2099: self = .aquamarine((points - 1500) / 100)
			case 2100...2599: self = .pearl((points - 2000) / 100)
			case 2600...3099: self = .diamond((points - 2500) / 100)
			case 3100...3599: self = .ruby((points - 3000) / 100)
			case 3600...4099: self = .sapphire((points - 3500) / 100)
			case 4100...4599: self = .emerald((points - 4000) / 100)
			case 4600... : 	  self = .blueDiamond((points - 4500) / 100)
			default: 		  self = .empty
		}
	}
}
