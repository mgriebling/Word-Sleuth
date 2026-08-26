//
//  Words.swift
//  Create Puzzles
//
//  Created by Michael Griebling on 22.06.2026.
//

import Foundation
import NaturalLanguage

public struct PlacedWord: Codable, Identifiable, Hashable {
	var word: String
	let direction: Direction
	var highlighted: Bool
	public let id: Int
	
	init(word:String, id: Int, direction: Direction = .right, highlighted: Bool = false) {
		self.word = word
		self.id = id
		self.highlighted = highlighted
		self.direction = direction
	}
}

public enum Direction: Int, Codable, CaseIterable {
	case left, right, down, up, diagonalUpLeft, diagonalUpRight,
		 diagonalDownLeft, diagonalDownRight
	
	var deltaCol: Int {
		switch self {
			case .left, .diagonalUpLeft, .diagonalDownLeft: return -1
			case .right, .diagonalUpRight, .diagonalDownRight: return 1
			case .up, .down: return 0
		}
	}
	
	var deltaRow: Int {
		switch self {
			case .down, .diagonalDownLeft, .diagonalDownRight: return 1
			case .up, .diagonalUpLeft, .diagonalUpRight: return -1
			case .left, .right: return 0
		}
	}
	
	static func random() -> Direction { Direction.allCases.randomElement()! }
}

public enum Language: String, Codable, CaseIterable, CustomStringConvertible {

	case english = "en", german = "de", spanish = "es", swedish = "sv"
	case norwegian = "no", italian = "it", french = "fr", japanese = "ja"
	case chinese = "zh", russian = "ru", hindi = "hi"
	case afrikaans = "af", arabic = "ar", greek = "el"
	case dutch = "nl", polish = "pl", hungarian = "hu"
	case slovak = "sk", romanian = "ro", danish = "da"
	case bulgarian = "bg", burmese = "my", cambodian = "km", czech = "cs"
	case estonian = "et", finnish = "fi", farsi = "fa", indonesian = "id"
	case hebrew = "he", icelandic = "is", korean = "ko", kurdish = "ku"
	case lithuanian = "lt", macedonian = "mk", mongolian = "mn"
	case navajo = "nv", portuguese = "pt", serbian = "sr", swahili = "sw"
	case turkish = "tr", ukrainian = "uk", vietnamese = "vi"
	case tibetan = "bo", yiddish = "yi"
	
	var alphabet: String { Alphabets.getAlphabet(for: self.rawValue) }
	
	public var description: String {
		let myLocale = Locale.current
		let name = myLocale.localizedString(forLanguageCode: self.rawValue)
		return name ?? "Unknown"
	}
	
	public static func getLanguage(from text: String) -> Language? {
		if let languageCode = NLLanguageRecognizer.dominantLanguage(for: text) {
			return Language(rawValue: languageCode.rawValue)
		} else {
			return nil
		}
	}
}

public struct WordList: Codable, Hashable {
	public var name: String
	public var language: Language
	public var author: String
	public var date: Date
	public var words: [String]
	
	init(name: String = "Empty", language: Language = .english,
		 author: String = "Unknown", date: Date = Date(), words: [String] = []) {
		self.name = name
		self.language = language
		self.author = author
		self.date = date
		self.words = words
	}
}
