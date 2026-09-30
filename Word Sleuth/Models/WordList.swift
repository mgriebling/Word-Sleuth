//
//  Words.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 22.06.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import Foundation
import NaturalLanguage

struct CellIndex: Equatable, Codable, Hashable, CustomStringConvertible {
	let row: Int
	let col: Int
	
	var description: String { "(\(row),\(col))" }
	
	init() { self.init(row: 0, col: 0) }
	
	init(row: Int, col: Int) {
		self.row = row
		self.col = col
	}
	
	func centerOfCell(cellSize: CGFloat, spacing: CGFloat, offset: CGFloat = 0) -> CGPoint {
		let x = CGFloat(col) * (cellSize + spacing) + cellSize / 2.0 + offset
		let y = CGFloat(row) * (cellSize + spacing) + cellSize / 2.0 + offset
		return CGPoint(x: x, y: y)
	}
	
	static func ifloor(_ point: CGPoint) -> CellIndex {
		let x = Int(point.x.rounded(.down))
		let y = Int(point.y.rounded(.down))
		return CellIndex(row: y, col: x)
	}
	
	static func - (lhs: CellIndex, rhs: CellIndex) -> CellIndex {
		CellIndex(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
	}
	
	static func + (lhs: inout CellIndex, rhs: Direction) -> CellIndex {
		CellIndex(row: lhs.row + rhs.deltaRow, col: lhs.col + rhs.deltaCol)
	}
	
	func limit(to row: Range<Int>, column: Range<Int>) -> CellIndex {
		let row = max(row.lowerBound, min(self.row, row.upperBound-1))
		let col = max(column.lowerBound, min(self.col, column.upperBound-1))
		return CellIndex(row: row, col: col)
	}
	
	func inRange(row: Range<Int>, column: Range<Int>) -> Bool {
		row.contains(self.row) && column.contains(self.col)
	}
}

public struct PlacedWord: Codable, Identifiable, Hashable {
	public let id: UUID
	let word: String
	private(set) var start: CellIndex
	private(set) var end: CellIndex
	private(set) var direction: Direction
	var highlighted: Bool { _colorIndex >= 0 }	  // color index if >= 0
	var _colorIndex: Int
	var extended: String  { word + start.description } // used as set element
	
	init(word:String, start:CellIndex = CellIndex(), end:CellIndex = CellIndex(),
		 direction:Direction = .right, highlighted:Int = -1) {
		self.word = word.lowercased()
		self.start = start
		self.end = end
		self._colorIndex = highlighted
		self.direction = direction
		self.id = UUID()
	}
	
	init(word:String, start:CellIndex = CellIndex(), direction:Direction, highlighted:Int = -1) {
		let len = max(0, word.count - 1)
		let end = CellIndex(row: start.row + (len * direction.deltaRow),
							col: start.col + (len * direction.deltaCol))
		self.init(word: word, start: start, end: end, direction: direction, highlighted: highlighted)
	}
	
	/// Adjusts the _start_ and _end_ indices and _direction_ for swapped rows/columns.
	func transpose() -> PlacedWord {
		var word = self
		word.start = CellIndex(row: start.col, col: start.row)
		word.end = CellIndex(row: end.col, col: end.row)
		word.direction = direction.transpose()
		return word
	}
}

public enum Direction: Int, Codable, CaseIterable {
	case left, right, down, up, diagonalUpLeft, diagonalUpRight,
		 diagonalDownLeft, diagonalDownRight
	
	/// Transposes the direction so _up_ is _down_, _left_ is _right_, etc.
	func transpose() -> Direction {
		switch self {
			case .left: .down
			case .right: .up
			case .down: .right
			case .up: .left
			case .diagonalUpLeft: .diagonalDownLeft
			case .diagonalDownLeft: .diagonalDownRight
			case .diagonalDownRight: .diagonalUpRight
			case .diagonalUpRight: .diagonalUpLeft
		}
	}
	
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

	case english = "en", german = "de", spanish = "es", italian = "it", french = "fr"
	case russian = "ru", hindi = "hi", dutch = "nl", polish = "pl"
	case portuguese = "pt", turkish = "tr", ukrainian = "uk"
	
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

public struct Filter {
	var maxWordCount = 100
	var minWordLength = 3
	var maxWordLength = SettingsType.maxRowRange.upperBound
	var filterCommonWords = true
}

public enum OwnerType: Codable, Equatable {
	case system /// owned by the system
	case random(size: Int, range: ClosedRange<Int>) /// random number generation
	case user   /// created by the user
}

@Observable public class WordList {

	public var name: String
	public var language: Language
	public var author: String
	public var date: Date
	public var words: [String]
	public var owner: OwnerType = .system
	
	public var averageLength: Double { Double(totalLetters) / max(1, Double(words.count)) }
	public var totalLetters: Int { words.reduce(0) { $1.count + $0	} }
	public var maxLength: Int { longestWord.count }
	public var longestWord: String { words.max(by: {$0.count < $1.count} ) ?? "" }
	public var placedWords: [PlacedWord] { words.map { PlacedWord(word: $0) } }
	
	convenience init() {
		self.init(name: "Empty", author: "Unknown", date: Date(), words: [])
	}
	
	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try container.decode(String.self, forKey: ._name)
		self.language = try container.decode(Language.self, forKey: .language)
		self.author = try container.decode(String.self, forKey: .author)
		self.date = try container.decode(Date.self, forKey: .date)
		self.words = try container.decode([String].self, forKey: .words)
		self.owner = try container.decode(OwnerType.self, forKey: .owner)
	}
	
	/// Create a copy of words
	convenience init(words: WordList) {
		self.init(name: words.name, author: words.author, date: words.date, words: words.words)
	}
	
	convenience init?(from file: URL) {
		if let rawData = try? Data(contentsOf: file) {
			let decoder = JSONDecoder()
			if let wordList = try? decoder.decode(WordList.self, from: rawData) {
				self.init(words: wordList)
				return
			} else {
				// remove corrupted file
				try? FileManager.default.removeItem(at: file)
			}
		}
		return nil
	}
	
	convenience init(name: String, author: String, from string: String, using prefs: Filter) {
		self.init()
		let wordLength = prefs.minWordLength...prefs.maxWordLength
		let words = string
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.components(separatedBy: .whitespacesAndNewlines
				.union(.punctuationCharacters))
			.filter {
				wordLength.contains($0.count) && // use wordLength words
				$0.uppercased() != $0 &&		 // ignore abbreviations
				$0.contains { $0.isLetter }		 // ignore words with non-letters
			}
			.map { $0.capitalized }
		let language = Language.getLanguage(from: string) ?? .english
		print("Found language \(language)")
		var finalWords = removePluralDuplicates(from: Set(words).sorted())
		if prefs.filterCommonWords {
			// remove commonly-occurring words
			finalWords = removeCommonWords(from: finalWords)
		}
		if finalWords.count > prefs.maxWordCount {
			// reduce the number of words
			finalWords = Array(finalWords.shuffled().prefix(prefs.maxWordCount))
		}
		self.init(name: name, author: author, words: finalWords)
		self.language = language
		self.owner = .user
	}
	
	init(name: String = "Empty", author: String = "Unknown", date: Date = Date(), words: [String], owner: OwnerType = .system) {
		self.name = name
		self.language = Language(rawValue: Locale.current.identifier) ?? .english
		self.author = author
		self.date = date
		self.words = words
		self.owner = owner
	}
	
	/// Get word list with random words of a certain size (i.e., wordRange)
	init(name: String = "Empty", author: String = "Unknown", date: Date = Date(),
		 wordRange: CountableClosedRange<Int>, totalWords: Int) {
		self.name = name
		self.language = Language(rawValue: Locale.current.identifier) ?? .english
		self.author = author
		self.date = date
		self.words = []    // created dynamically during Puzzle init
		self.owner = .random(size: totalWords, range: wordRange)
	}
	
	/// Creates a copy of the word list
	func copy() -> WordList { WordList(words: self) }
	
	static var fileExt: String { "wlist" }
	
	static var documentDirectory: URL? {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	func url(name: String) -> URL {
		Self.documentDirectory!.appending(path: "\(name).\(Self.fileExt)")
	}
	
	/// Removes any common words
	func removeCommonWords(from words: [String]) -> [String] {
		var result = [String]()
		let commonWords = Set(SampleWords.commonWords)
		for word in words {
			if !commonWords.contains(word) {
				result.append(word)
			}
		}
		return result
	}
	
	/// Removes words that are plural duplicates from the set of *words*.
	func removePluralDuplicates(from sortedWords: [String]) -> [String] {
		// 1. Clean and lowercase the words, sorting by length so singular words appear first
		var uniqueSingulars = Set<String>()
		var result: [String] = []
		
		for word in sortedWords {
			var singularForm = word
			
			// Check common English plural suffixes and generate a singular form
			if word.hasSuffix("ies") && word.count > 3 {
				// e.g., "babies" -> "baby"
				singularForm = String(word.dropLast(3)) + "y"
			} else if word.hasSuffix("es") && word.count > 2 {
				// e.g., "boxes" -> "box"
				singularForm = String(word.dropLast(2))
			} else if word.hasSuffix("s") && word.count > 1 {
				// e.g., "cats" -> "cat"
				singularForm = String(word.dropLast(1))
			}
			
			// If neither the singular form nor the word itself has been seen, keep it
			if !uniqueSingulars.contains(singularForm) && !uniqueSingulars.contains(word) {
				uniqueSingulars.insert(singularForm)
				uniqueSingulars.insert(word)
				result.append(word) // Keeps the original singular word
			}
		}
		
		return result
	}
	
	/// Saves the word list to a file
	func save(to fileName: String) {
		// 4. Initialize JSONEncoder and format the output
		let encoder = JSONEncoder()

		do {
			// 5. Encode the class instance into raw Data
			let jsonData = try encoder.encode(self)
			
			// 6. Write the raw Data to disk
			try jsonData.write(to: url(name: fileName), options: .atomic)
		} catch {
			print("Failed to write JSON file: \(error.localizedDescription)")
		}
	}
	
	func delete() {
		try? FileManager.default.removeItem(at: url(name: self.name))
	}
	
	func resource(from s: String, list: Int, word: Int = 0) -> String {
		let comment = word == 0 ? "L\(list)-Title" : "L\(list)-word \(word)"
		return "LocalizedStringResource(\"\(s)\", table: \"WordLists\", comment: \"\(comment)\")"
	}
	
	func makeWordListCode(list: Int) {
		let name = resource(from: name, list: list)
		var fileWords: String = "WordList(name2: \(name), \n\twords2: [\n"
		for (i, word) in words.enumerated() {
			fileWords.append("\t\t\(resource(from: word, list: list, word: i+1)),\n")
		}
		fileWords.append("\t]),")
		print(fileWords, "\n\n")
	}
 
	static func makeWordListCode(for wordLists: [WordList]) {
		print("struct SampleWordLists {\n\tstatic var all: [WordList] { [\n")
		wordLists.indices.forEach { index in
			wordLists[index].makeWordListCode(list: index+1)
		}
		print("\t]}\n}")
	}
	
	static func save(wordLists: [WordList]) {
		wordLists.forEach { wordList in
			wordList.save(to: wordList.name)
		}
	}
	
	static func loadWordLists() -> [WordList] {
		guard let documentsURL = Self.documentDirectory else { return [] }
		let fileManager = FileManager.default
		do {
			let contents = try fileManager.contentsOfDirectory(at: documentsURL,
					includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
			
			// Filter for files with fileExt extension (case-insensitive)
			let wordListURLs = contents.filter { $0.pathExtension.lowercased() == fileExt }
			var wordLists = [WordList]()
			for url in wordListURLs {
				if let wordList = WordList(from: url) {
					wordLists.append(wordList)
				}
			}
			return wordLists
		} catch {
			print("Error reading directory: \(error)")
			return []
		}
	}
	
	static func loadSystemWords() -> [String] {
		//let language = Locale.preferredLanguages.first ?? "en"
		// Force just the base two-letter prefix (e.g., "en-US" -> "en")
		let language = Locale.preferredLanguages.first?
			.components(separatedBy: "-").first ?? "en"
		guard let wordFilePath = Bundle.main.path(forResource: "words_\(language)", ofType: "txt"),
			  let content = try? String(contentsOfFile: wordFilePath, encoding: .utf8) else {
			return ["error", "fallback", "words"]
		}
		
		print("Loaded words_\(language).txt")
		
		// FIX 1: Map to standard Strings to break the Substring memory reference back to 'content'
		// FIX 2: Filter out empty lines immediately so .randomElement() never picks a blank space
		return content.components(separatedBy: .newlines)
			.map { String($0) }
			.filter { !$0.isEmpty }
	}

	static var largeWordBank = loadSystemWords()

	static func generateWords(with size: CountableClosedRange<Int>, total: Int) -> [String] {
		// FIX 3: Use a Set for 'words' instead of an Array.
		// Checking `!words.contains(...)` on a massive array in a loop is incredibly slow
		// and can cause thread timeouts outside the debugger.
		var words = Set<String>()
		
		// FIX 4: Add a safety breakout counter so your production app can NEVER infinitely loop
		var attempts = 0
		let maxAttempts = total * 100
		
		while words.count < total && attempts < maxAttempts {
			attempts += 1
			
			if let word = largeWordBank.randomElement() {
				let capitalizedWord = word.capitalized
				if size.contains(word.count) && !words.contains(capitalizedWord) {
					words.insert(capitalizedWord)
				}
			}
		}
		
		return Array(words).sorted()
	}
}

// Needed to handcode to prevent compiler warning with observable/codable
extension WordList: Codable {
	
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(_name, forKey: ._name)
		try container.encode(language, forKey: .language)
		try container.encode(author, forKey: .author)
		try container.encode(date, forKey: .date)
		try container.encode(words, forKey: .words)
		try container.encode(owner, forKey: .owner)
	}
	
	enum CodingKeys: String, CodingKey {
		case _name, language, author, date, words, owner
	}
}

extension WordList: Identifiable { }  // auto-generated

extension WordList: Equatable {
	static public func == (lhs: WordList, rhs: WordList) -> Bool {
		lhs.name == rhs.name &&
		lhs.words == rhs.words &&
		lhs.author == rhs.author &&
		lhs.language == rhs.language &&
		lhs.date == rhs.date &&
		lhs.owner == rhs.owner
	}
}

extension WordList: Hashable {
	public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
