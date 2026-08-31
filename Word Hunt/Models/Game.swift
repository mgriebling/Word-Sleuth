//
//  Game.swift
//  Word Hunt
//
//  Created by Mike Griebling on 2022-11-09.
//

import SwiftUI

@Observable class Game {
	private var _board: GameBoard
	var board: GameBoard {
		get { invert ? _board.transpose() : _board }
		set { _board = newValue }
	}
	var timer: MyTimer
	var creationDate: Date
	var badges: [Badge] = []
	
	private let oneWeek: TimeInterval = 7 * 24 * 60 * 60 // seconds/week
	
	// MARK: Convenience attributes
	var placedWords: [PlacedWord] { _board.wordPlacements }
	var rows: Int		   		  { _board.rows }
	var cols: Int				  { _board.cols }
	var name: String			  { _board.words.name }
	var matched: Int 			  { placedWords.filter({ $0.highlighted }).count }
	var words: [String]			  { placedWords.map { $0.word }}
	var isOver: Bool 		  	  { matched == placedWords.count }
	var isRecent: Bool 		  	  { creationDate.timeIntervalSinceNow < oneWeek }
	
	var selectedWord: String = ""
	var invert: Bool = false
	
	// MARK: Initializer
	init(level: Level, words: WordList) {
		self._board = GameBoard(size: level.size, words: words)
		self.timer = MyTimer(name: words.name)
		self.creationDate = .now
	}
	
	convenience init(size: Int, words: WordList) {
		self.init(size, cols: size, words: words)
	}
	
	init(_ rows: Int, cols: Int, words: WordList) {
		assert(SettingsType.maxRowRange.contains(rows), "Expecting rows in \(SettingsType.maxRowRange)")
		assert(SettingsType.maxColRange.contains(cols), "Expecting columns in \(SettingsType.maxColRange)")
		if UIDevice.current.userInterfaceIdiom == .phone {
			self._board = GameBoard(rows, cols: min(12, cols), words: words)
		} else {
			self._board = GameBoard(rows, cols: cols, words: words)
		}
		self.timer = MyTimer(name: words.name)
		self.creationDate = .now
	}
	
	/// Copies a game
	init(game: Game) {
		self._board = game._board
		self.timer = game.timer
		self.badges = game.badges
		self.creationDate = game.creationDate
	}
	
	// MARK: Required for manual Codable compliance, warning issued otherwise
	required init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self._board = try container.decode(GameBoard.self, forKey: .board)
		self.timer = try container.decode(MyTimer.self, forKey: .timer)
		self.badges = try container.decode([Badge].self, forKey: .badges)
		self.creationDate = try container.decode(Date.self, forKey: .creationDate)
	}
	
	convenience init?(from file: URL) {
		if let rawData = try? Data(contentsOf: file) {
			let decoder = JSONDecoder()
			if let game = try? decoder.decode(Game.self, from: rawData) {
				print("Loaded game: \(game.name)")
				self.init(game: game)
				return
			} else {
				// remove corrupted file
				try? FileManager.default.removeItem(at: file)
			}
		}
		return nil
	}
	
	var level: Int {
		// first calculate average difficulty level of the words (5 is typical word length)
		let averageWordLength = 6.0
		let cells = SettingsType.maxRowRange.upperBound * SettingsType.maxColRange.upperBound
		let wordsCount = Double(placedWords.count)
		let wordScore = placedWords.map({ Double($0.word.count) }).reduce(0, +) /
						(wordsCount * averageWordLength)
		let puzzleScore = Double(rows * cols) / Double(cells)
		let numberOfWordsScore = wordsCount / Double(board.words.words.count)
		let total = wordScore + puzzleScore + numberOfWordsScore
		return min(10, Int((10.0 / 3.0) * total + 0.5))
	}
	
	func setOrientation(landscape: Bool) {
		self.invert = landscape && (self.rows > self.cols)
	}
	
	/// Saves the game to a file
	func save(to fileName: String) {
		let encoder = JSONEncoder()
		// encoder.dataEncodingStrategy = .deferredToData
		// encoder.outputFormatting = .prettyPrinted // Makes the JSON file human-readable
		
		do {
			// 5. Encode the class instance into raw Data
			let jsonData = try encoder.encode(self)
			
			// 6. Write the raw Data to disk
			try jsonData.write(to: url(name: fileName), options: .atomic)
			print("Saved game \(fileName)")
		} catch {
			print("Failed to write JSON file: \(error.localizedDescription)")
		}
	}
	
	static var documentDirectory: URL? {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	static var fileExt: String { "wordsleuth" }
	
	func url(name: String) -> URL {
		Self.documentDirectory!.appendingPathComponent("\(name).\(Self.fileExt)")
	}
	
	static func save(games: [Game]) { games.forEach { $0.save(to: $0.name) } }
	
	static func loadGames() -> [Game] {
		guard let documentsURL = Self.documentDirectory else { return [] }
		let fileManager = FileManager.default
		do {
			let contents = try fileManager.contentsOfDirectory(at: documentsURL,
					includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
			
			// Filter for files with extension (case-insensitive)
			let gameURLs = contents.filter { $0.pathExtension.lowercased() == Self.fileExt }
			var games = [Game]()
			for url in gameURLs {
				if let game = Game(from: url) {
					games.append(game)
				}
			}
			return games
		} catch {
			print("Error reading directory: \(error)")
			return []
		}
	}
	
	func reverseSelection() {
		selectedWord = String(selectedWord.reversed())
	}
	
	func delete() {
		try? FileManager.default.removeItem(at: url(name: self.name))
	}
	
	func placeWords(words: [String]) -> [PlacedWord] {
		words.map { PlacedWord(word: $0) }
	}
	
	func copy() -> Game { Game(game: self) }
  
}

extension Game: Identifiable { }  // auto-generated

extension Game: Equatable {
	static public func == (lhs: Game, rhs: Game) -> Bool {
		lhs.id == rhs.id
	}
}

extension Game: Codable {

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(board, forKey: .board)
		try container.encode(timer, forKey: .timer)
		try container.encode(badges, forKey: .badges)
		try container.encode(creationDate, forKey: .creationDate)
	}
	
	enum CodingKeys: String, CodingKey { case board, timer, badges, creationDate }
}

extension Game: Hashable {
	func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
	
