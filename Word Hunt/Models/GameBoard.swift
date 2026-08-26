//
//  Board.swift
//  Word Hunt
//
//  Created by Mike Griebling on 2022-11-09.
//

import Foundation

struct Cell: Codable, Identifiable, Equatable, Hashable {
    let letter: String
    let id: UUID
    
	init(letter: String) {
		self.letter = letter
        self.id = UUID()
    }
	
	// Initializes with random character
	init() { self.init(letter: Cell.randomCharacter) }
	
	static let alphabet = Array(Alphabets.englishAlphabet)
	static var randomCharacter: String {
		String(alphabet[Int.random(in: 0..<alphabet.count)])
	}
}

struct GameBoard: Codable, Equatable, Hashable {
	var rows, cols: Int
	var rcsize: Int { rows * cols }
    
    private(set) var board = [Cell]()

	// active set of words
	private(set) var words: WordList
	
    // placement of all words
    private(set) var wordPlacements = [PlacedWord]()
	private(set) var missingWords = [String]()
	
	init(_ rows: Int, cols: Int, words: WordList = WordList()) {
		self.rows = rows
		self.cols = cols
		self.words = words
		wordPlacements = []
		board = []
		missingWords = []
		
		// iterate to find the best board placement
		if words.words.isEmpty {
			randomFillBoard()
		} else {
			bestPlacement(words.words)
			
			// fill gaps with random letters
			for i in 0..<rcsize {
				if board[i].letter == " " {
					board[i] = Cell()
				}
			}
		}
	}
	
	init(size: Int, words: WordList = WordList()) {
		self.init(size, cols: size, words: words)
	}
	
	private mutating func randomFillBoard() {
		// fill with random characters
		let ultraFastArray = [Cell](unsafeUninitializedCapacity: rcsize) { buffer, initializedCount in
			buffer.initialize(repeating: Cell(letter: " "))
			for i in 0..<rcsize {
				buffer[i] = Cell()  // fill with random letters
			}
			// You must manually specify how many items were initialized
			initializedCount = rcsize
		}
		board = ultraFastArray
	}
	
	private func printBoard(board: GameBoard) {
		for i in 0..<board.board.count {
			var ch = board.board[i].letter
			if ch == " " { ch = "." }
			print(ch, terminator: "")
			if (i+1) % board.cols == 0 { print() }
		}
	}
	
	private mutating func bestPlacement(_ words: [String]) {
		var unplaced = 0
		var limit = 10
		var bestPlacement = 100
		var bestPlacementWords = [PlacedWord]()
		var bestBoard = [Cell]()
		repeat {
			clearBoard()
			wordPlacements = []
			unplaced = generatePuzzle(with: words)
			if unplaced < bestPlacement {
				bestPlacement = unplaced
				bestPlacementWords = wordPlacements
				bestBoard = board
			}
			limit -= 1
		} while unplaced > 0 && limit > 0
		
		// show final placements
		board = bestBoard
		wordPlacements = bestPlacementWords.sorted(by: { $0.word < $1.word } )

		let newSet = Set(wordPlacements.map(\.word))
		missingWords = words.filter { !newSet.contains($0.lowercased()) }.sorted(by: <)
	}
	
	mutating func clearBoard() {
		// place blanks everywhere
		board = Array(repeating: Cell(letter: " "), count: rcsize)
	}
	
	// Checks placement validity and scores the quality of the overlap
	private func scorePlacement(for word: String, atRow row: Int, col: Int, direction: Direction) -> Int? {
		let letters = Array(word.uppercased())
		var currentScore = 0
		
		for i in 0..<letters.count {
			let newRow = row + (i * direction.deltaRow)
			let newCol = col + (i * direction.deltaCol)
			
			// 1. Fail if out of bounds
			guard newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols else {
				return nil
			}
			
			// 2. Fail if there is a letter conflict
			let currentCell = board[indexOf(newRow, column: newCol)].letter
			if currentCell != " " && currentCell != String(letters[i]) {
				return nil
			}
			
			// 3. Reward valid overlaps
			if currentCell == String(letters[i]) {
				currentScore += 10
			}
		}
		
		return currentScore
	}
	
	// Write the word letters into the matrix
	private mutating func placeWord(_ word: String, atRow row: Int, col: Int, direction: Direction) {
		let letters = Array(word.uppercased())
		for i in 0..<letters.count {
			let newRow = row + (i * direction.deltaRow)
			let newCol = col + (i * direction.deltaCol)
			let index = indexOf(newRow, column:newCol)
			board[index] = Cell(letter: String(letters[i]))
		}
		
		// add word to the word database
		let start = CellIndex(row: row, col: col)
		wordPlacements.append(PlacedWord(word: word.lowercased(), start: start, direction: direction))
	}
	
	// Check if the word fits at the given coordinates
	private func canPlaceWord(_ word: String, atRow row: Int, col: Int, direction: Direction) -> Bool {
		let letters = Array(word.uppercased())
		for i in 0..<letters.count {
			let newRow = row + (i * direction.deltaRow)
			let newCol = col + (i * direction.deltaCol)
			
			// Check bounds
			guard
				newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols
			else {
				return false
			}
			
			// Check conflicts (empty spaces or matching characters are fine)
			let currentCell = board[indexOf(newRow, column: newCol)].letter
			if currentCell != " " && currentCell != String(letters[i]) {
				return false
			}
		}
		return true
	}
	
	// Automatically loops through all words and places them randomly
	private mutating func generatePuzzle(with words: [String]) -> Int {
		// Sort words by length so long words establish a base infrastructure first
		let sortedWords = words.sorted { $0.count > $1.count }
		var unplaced = 0
		
		for word in sortedWords {
			var bestRow = 0
			var bestCol = 0
			var bestDirection = Direction.right
			var maxScore = -1
			
			// Test 150 random combinations to find the best overlapping spot
			let sampleSize = 150
			for _ in 0..<sampleSize {
				let r = Int.random(in: 0..<rows)
				let c = Int.random(in: 0..<cols)
				guard let d = Direction.allCases.randomElement() else { continue }
				
				if let score = scorePlacement(for: word, atRow: r, col: c, direction: d) {
					// Introduce a tiny random bonus (+0 or +1) so non-overlapping words
					// don't always cluster in the top-left corner (0,0) when maxScore is 0
					let tieBreakerScore = score + Int.random(in: 0...1)
					
					if tieBreakerScore > maxScore {
						maxScore = tieBreakerScore
						bestRow = r
						bestCol = c
						bestDirection = d
					}
				}
			}
			
			// If maxScore is still -1, it means no valid spot was found in 150 tries
			if maxScore >= 0 {
				placeWord(word, atRow: bestRow, col: bestCol, direction: bestDirection)
			} else {
				unplaced += 1
			}
		}
		return unplaced
	}
	
	mutating func highlightWord(_ index: Int, _ colorIndex: Int = 0) {
		wordPlacements[index]._colorIndex = colorIndex
	}
	
	mutating func unhighlightWord(_ index: Int) {
		wordPlacements[index]._colorIndex = -1
	}
	
	func transpose() -> GameBoard {
		if rows <= cols { return self }
		var swapped = Array(repeating: Cell(letter: " "), count: rcsize)
		// printBoard(board: self)
		
		// Swap the rows and columns
		for row in 0..<rows {
			for col in 0..<cols {
				swapped[col * rows + row] = self[row, col]
			}
		}
		
		// Adjust the highlighting
		var placements = self.wordPlacements
//		print("-------------------------------------")
//		print(placements); print()
		for (index, placement) in placements.enumerated() {
			placements[index] = placement.transpose()
		}
//		print(placements)
		
		var newBoard = self
		newBoard.board = swapped
		newBoard.wordPlacements = placements
		swap(&newBoard.rows, &newBoard.cols)
		// printBoard(board: newBoard)
		return newBoard
	}
	
    func indexOf(_ row: Int, column: Int) -> Int {
		let row = max(0, min(row, rows-1))
		let column = max(0, min(column, cols-1))
		return row * cols + column
    }
    
    func indexToRowCol(_ index:Int) -> (row:Int, col:Int) {
		guard rcsize > 0 && index < rcsize else { return (row: 0, col: 0) }
		return (row: index / cols, col: index % cols)
    }
    
    public subscript(row:Int, column:Int) -> Cell {
        get { board[indexOf(row, column: column)] }
        set { board[indexOf(row, column: column)] = newValue }
    }
    
}
