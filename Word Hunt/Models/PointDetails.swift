//
//  PointDetails.swift
//  Word Hunt
//
//  Created by Michael Griebling on 16.09.2026.
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
	
	init(points: Int) {
		switch points {
			case 100...399:   self = .topaz(points / 100)
			case 400...699:   self = .citrine((points - 300) / 100)
			case 700...999:   self = .amethyst((points - 600) / 100)
			case 1000...1299: self = .aquamarine((points - 900) / 100)
			case 1300...1599: self = .pearl((points - 1200) / 100)
			case 1600...1899: self = .diamond((points - 1500) / 100)
			case 1900...2199: self = .ruby((points - 1800) / 100)
			case 2200...2499: self = .sapphire((points - 2100) / 100)
			case 2500...2799: self = .emerald((points - 2400) / 100)
			case 2800... : 	  self = .blueDiamond((points - 2700) / 100)
			default: 		  self = .empty
		}
	}
}
