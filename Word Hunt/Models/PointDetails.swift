//
//  PointDetails.swift
//  Word Hunt
//
//  Created by Michael Griebling on 16.09.2026.
//

import SwiftUI

enum PointDetails: Int, Codable, CaseIterable  {
	case topaz, citrine, amethyst, aquamarine, pearl
	case diamond, ruby, sapphire, emerald, blueDiamond
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
			case 100...199: self = .topaz
			case 200...299: self = .citrine
			case 300...399: self = .amethyst
			case 400...499: self = .aquamarine
			case 500...599: self = .topaz
			case 600...699: self = .citrine
			case 700...799: self = .amethyst
			case 800...899: self = .aquamarine
			case 900...999: self = .amethyst
			case 1000... : self = .aquamarine
			default: self = .empty
		}
	}
}
