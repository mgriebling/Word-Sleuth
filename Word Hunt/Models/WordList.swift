//
//  Words.swift
//  Word Hunt
//
//  Created by Michael Griebling on 22.06.2026.
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

struct PlacedWord: Codable, Identifiable, Hashable {
	let id: UUID
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

@Observable public class WordList {

	public var name: String
	public var language: Language
	public var author: String
	public var date: Date
	public var words: [String]
	
	public var averageLength: Double {
		words.map({ Double($0.count) }).reduce(0, +) / Double(words.count)
	}
	
	public var maxLength: Int { longestWord.count }
	
	public var longestWord: String {
		words.max(by: {$0.count < $1.count} ) ?? ""
	}
	
	convenience init() {
		self.init(name: "Empty", language: .english,
				  author: "Unknown", date: Date(), words: [])
	}
	
	required public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self._name = try container.decode(String.self, forKey: ._name)
		self.language = try container.decode(Language.self, forKey: .language)
		self.author = try container.decode(String.self, forKey: .author)
		self.date = try container.decode(Date.self, forKey: .date)
		self.words = try container.decode([String].self, forKey: .words)
	}
	
	/// Create a copy of words
	convenience init(words: WordList) {
		self.init(name: words.name, language: words.language,
			 author: words.author, date: words.date, words: words.words)
	}
	
	convenience init?(from file: URL) {
		if let rawData = try? Data(contentsOf: file) {
			let decoder = JSONDecoder()
			if let wordList = try? decoder.decode(WordList.self, from: rawData) {
				print("Loaded word List: \(wordList.name)")
				self.init(words: wordList)
				return
			} else {
				// remove corrupted file
				try? FileManager.default.removeItem(at: file)
			}
		}
		return nil
	}
	
	init(name: String = "Empty", language: Language = .english,
		 author: String = "Unknown", date: Date = Date(), words: [String]) {
		self._name = name
		self.language = language
		self.author = author
		self.date = date
		self.words = words
	}
	
	/// Get word list with random words of a certain size (i.e., wordRange)
	init(name: String = "Empty", language: Language = .english,
		 author: String = "Unknown", date: Date = Date(),
		 wordRange: CountableClosedRange<Int>, totalWords: Int) {
		//print("Creating word list")
		self._name = name
		self.language = language
		self.author = author
		self.date = date
		self.words = Self.generateWords(with: wordRange, total: totalWords)
	}
	
	/// Creates a copy of the word list
	func copy() -> WordList { WordList(words: self) }
	
	static var fileExt: String { "wlist" }
	
	static var documentDirectory: URL? {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	func url(name: String) -> URL {
		Self.documentDirectory!.appendingPathComponent("\(name).\(Self.fileExt)")
	}
	
	/// Saves the word list to a file
	func save(to fileName: String) {
		// 4. Initialize JSONEncoder and format the output
		let encoder = JSONEncoder()
		// encoder.outputFormatting = .prettyPrinted // Makes the JSON file human-readable
		
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
		if let wordFilePath = Bundle.main.path(forResource: "top25K-english", ofType: "txt") {
			if let content = try? String(contentsOfFile: wordFilePath, encoding: .utf8) {
				return content.components(separatedBy: .newlines)
			}
		}
		return ["error", "fallback", "words"]
	}

	static let largeWordBank = loadSystemWords()
	
	static private func generateWords(with size: CountableClosedRange<Int>, total: Int) -> [String] {
		var words: [String] = []
		while words.count < total {
			if let word = largeWordBank.randomElement() {
				if size.contains(word.count), !words.contains(word.capitalized) {
					words.append(word.capitalized)
				}
			}
		}
		return words.sorted()
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
	}
	
	enum CodingKeys: String, CodingKey {
		case _name, language, author, date, words, revision
	}
}

extension WordList: Identifiable { }  // auto-generated

extension WordList: Equatable {
	static public func == (lhs: WordList, rhs: WordList) -> Bool {
		lhs.id == rhs.id
	}
}

extension WordList: Hashable {
	public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
