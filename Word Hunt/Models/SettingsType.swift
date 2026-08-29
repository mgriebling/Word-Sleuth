//
//  Settings.swift
//  Word Hunt
//
//  Created by Michael Griebling on 04.07.2026.
//

import SwiftUI

public struct SettingsType {
	static let maxRowRange = 5...20
	static let maxColRange = 5...20
	
	var player: Player
	
	var gameNumber: Int
	var level: Level
	
	var highlight: HighLight
	var selectionColor: Color
	var selectionOKColor: Color
	var highlightColor: Color
	
	var soundsOn: Bool
	var soundVolume: Double
	
	var showTimer: Bool
	
	var horizontal: Horizontal
	var vertical: Vertical
	
	var fontStyle: FontStyle
	
	var sortAcrossCols: Bool
	
	var sortPuzzles: PuzzleOrder
	var sortIncreasing: Bool
	
	init() {
		self.gameNumber = 1
		self.player = Player()
		self.highlight = .allCases.first!
		self.selectionColor = Color(.selectionRed)
		self.selectionOKColor = Color(.selectionGreen)
		self.highlightColor = Color(.selectionYellow)
		self.soundsOn = true
		self.soundVolume = 0.2
		self.showTimer = true
		self.horizontal = .left
		self.vertical = .below
		self.level = .five
		self.fontStyle = .regular
		self.sortAcrossCols = true
		self.sortPuzzles = .manual
		self.sortIncreasing = true
	}
	
	init(_ settings: Self) {
		self = settings
	}
}

public extension AppStorageKey where Value == SettingsType {
	static let settings = AppStorageKey("settings", defaultValue: SettingsType())
}

extension SettingsType: Codable {
	enum CodingKeys: String, CodingKey {
		case gameNumber, player, highlight, selectionColor,
			 selectionOKColor, highlightColor, soundsOn, soundVolume, showTimer,
			 horizontal, vertical, level, fontStyle, sortAcrossCols,
			 sortPuzzles, sortIncreasing
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.gameNumber = try container.decode(Int.self, forKey: .gameNumber)
		self.player = try container.decode(Player.self, forKey: .player)
		self.highlight = try container.decode(HighLight.self, forKey: .highlight)
		self.selectionColor = try container.decode(Color.self, forKey: .selectionColor)
		self.selectionOKColor = try container.decode(Color.self, forKey: .selectionOKColor)
		self.highlightColor = try container.decode(Color.self, forKey: .highlightColor)
		self.soundsOn = try container.decode(Bool.self, forKey: .soundsOn)
		self.soundVolume = try container.decode(Double.self, forKey: .soundVolume)
		self.showTimer = try container.decode(Bool.self, forKey: .showTimer)
		self.horizontal = try container.decode(Horizontal.self, forKey: .horizontal)
		self.vertical = try container.decode(Vertical.self, forKey: .vertical)
		self.level = try container.decode(Level.self, forKey: .level)
		self.fontStyle = try container.decode(FontStyle.self, forKey: .fontStyle)
		self.sortAcrossCols = try container.decode(Bool.self, forKey: .sortAcrossCols)
		self.sortPuzzles = try container.decode(PuzzleOrder.self, forKey: .sortPuzzles)
		self.sortIncreasing = try container.decode(Bool.self, forKey: .sortIncreasing)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.gameNumber, forKey: .gameNumber)
		try container.encode(self.player, forKey: .player)
		try container.encode(self.highlight, forKey: .highlight)
		try container.encode(self.selectionColor, forKey: .selectionColor)
		try container.encode(self.selectionOKColor, forKey: .selectionOKColor)
		try container.encode(self.highlightColor, forKey: .highlightColor)
		try container.encode(self.soundsOn, forKey: .soundsOn)
		try container.encode(self.soundVolume, forKey: .soundVolume)
		try container.encode(self.showTimer, forKey: .showTimer)
		try container.encode(self.horizontal, forKey: .horizontal)
		try container.encode(self.vertical, forKey: .vertical)
		try container.encode(self.level, forKey: .level)
		try container.encode(self.fontStyle, forKey: .fontStyle)
		try container.encode(self.sortAcrossCols, forKey: .sortAcrossCols)
		try container.encode(self.sortPuzzles, forKey: .sortPuzzles)
		try container.encode(self.sortIncreasing, forKey: .sortIncreasing)
	}
}

extension SettingsType: RawRepresentable {
	
	public var rawValue: String {
		do {
			let jsonData = try JSONEncoder().encode(self)
			let jsonString = String(data: jsonData, encoding: .utf8)
			return jsonString ?? "Unable to convert to string"
		} catch {
			return ""
		}
	}
	
	public init?(rawValue: String) {
		if let jsonData = rawValue.data(using: .utf8) {
			if let settings = try? JSONDecoder().decode(SettingsType.self, from: jsonData) {
				self.init(settings)
				return
			}
		}
		return nil
	}
}

enum FontStyle: Int, CaseIterable, Identifiable, Codable {
	case ultraLight, thin, light, regular, medium, semiBold, bold, black
	
	var weight: Font.Weight {
		switch self {
			case .ultraLight: Font.Weight.ultraLight
			case .thin:		  Font.Weight.thin
			case .light:   	  Font.Weight.light
			case .regular: 	  Font.Weight.regular
			case .medium:  	  Font.Weight.medium
			case .semiBold:	  Font.Weight.semibold
			case .bold:    	  Font.Weight.bold
			case .black:   	  Font.Weight.black
		}
	}
	
	var id: Self { self }
}

enum PuzzleOrder: String, CaseIterable, Identifiable, Codable {
	case manual = "Man", level = "Level", name = "Name", date = "Date"
	
	var id: Self { self }
}

enum Level: String, CaseIterable, Identifiable, Codable {
	case manual = "Man", three = "3", four = "4", five = "5", six = "6"
	case seven = "7", eight = "8", nine = "9", ten = "10"
	
	var value: Int { Int(self.rawValue) ?? 0 }
	
	/// returns the game grid size to give this level
	var size: Int {
		switch self {
			case .three:  5
			case .four:   6
			case .five:   9
			case .six: 	 11
			case .seven: 12
			case .eight: 15
			case .nine:  18
			case .ten:   20
			default: 	  5
		}
	}

	var id: Self { self }
}

enum CreationMode: String, CaseIterable, Identifiable, Codable {
	case oneGame = "1", twoGames = "2", threeGames = "3", fourGrames = "4",
		 fiveGames = "5", custom = "Custom"
	var number: Int { Int(self.rawValue) ?? 1 }
	var id: Self { self }
}

enum HighLight: CaseIterable, Identifiable, Codable {
	case outline, fill, outlineFill, colorFill
	
	var isFill: Bool { self == .fill || self == .outlineFill }
	var isOutline: Bool { self == .outline || self == .outlineFill }
	var isColor: Bool { self == .colorFill }
	
	var name: String {
		switch self {
			case .outline: 	   "Outline"
			case .fill: 	   "Fill"
			case .outlineFill: "Outline & Fill"
			case .colorFill:   "Color Fill"
		}
	}
	

	var image: String {
		if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
			switch self {
				case .outline: 	   "capsule"
				case .fill: 	   "capsule.fill"
				case .outlineFill: "capsule.inset.filled"
				case .colorFill:   "capsule.on.capsule.fill"
			}
		} else {
			switch self {
				case .outline: 	   "rectangle"
				case .fill: 	   "rectangle.fill"
				case .outlineFill: "rectangle.inset.filled"
				case .colorFill:   "rectangle.on.rectangle.fill"
			}
		}
	}
	
	var id: Self { self }
}

enum Vertical: String, CaseIterable, Identifiable, Codable {
	case above, below

	var id: Self { self }
}

enum Horizontal: String, CaseIterable, Identifiable, Codable {
	case left, right

	var id: Self { self }
}
