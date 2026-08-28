//
//  CapsuleHighlight.swift
//  Word Hunt
//
//  Created by Google AI on 30.06.2026.
//  Modified by M. Griebling on 30.06.2026.
//

import SwiftUI
// import Subsonic

/// Row x Col Game Board Matrix
struct LetterGridView: View {
	let game: Game
	var allowDrag: Bool = false
	var isLandscape: Bool = false
	
	@Binding var settings: SettingsType
	
	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	@Environment(\.colorScheme) var colorScheme
	@Environment(DataContainer.self) private var dataContainer

	// Active Interaction States
	@State private var dragStartCell: CellIndex?
	@State private var dragCurrentCell: CellIndex?
	@State private var selectionDirection: Direction?
	@State private var placedSet = Set<String>()
	
	@State private var numRows = 1
	@State private var numCols = 1
	@State private var animateWin = false
	@State private var done: Bool = false
	//@State private var deviceOrientation = UIDevice.current.orientation
	//@State private var board = GameBoard(size: 1, words: WordList())
	
	@State private var cellSize: CGFloat = 40
	@State private var width: CGFloat = 400
	
	@State private var backColors = [
		Color(.systemCyan).opacity(0.3),
		Color(.systemBackground),
		Color(.systemGray).opacity(0.4)
	]
	
	let spacing: CGFloat = 0	// space between columns and rows
	let colors = [Color.red, .orange, .yellow, .green, .blue, .purple, .pink, .mint]
	let color = Color(.systemCyan)

	var body: some View {
		let isCompact = horizontalSizeClass == .compact
		let padding: CGFloat = isCompact ? 10 : 20  // space between frame and letters
		
		newGrid(board: game.board)
			.padding(padding)
			.coordinateSpace(name: "GridSpace")
			.background {
				// Backdrop
				RoundedRectangle(cornerRadius: 20)
					.fill(LinearGradient(colors: backColors, startPoint: .bottom, endPoint: .top))
				RoundedRectangle(cornerRadius: 20)
					.strokeBorder(color, lineWidth: isCompact ? 2 : 4)
				
				// 2. Persistent Layer: Displays correctly guessed historical word
				ForEach(game.board.wordPlacements) { word in
					if word.highlighted {
						capsuleView(board: game.board, cellSize: cellSize, start: word.start, end: word.end, selected: false, padding: padding, highlighted: word._colorIndex)
					}
				}
				
				// 3. Active Layer: Current continuous user gesture drag highlight
				if let start = dragStartCell, let end = dragCurrentCell {
					capsuleView(board: game.board, cellSize: cellSize, start: start, end: end, selected: true, padding: padding)
				}
			}
			.onAppear {
				let invert = isLandscape && (game.rows > game.cols)
				// board = invert ? game.transpose() : game.board
//				settings.highlight = .colorFill
//				settings.highlightColor = Color(.selectionYellow)
//				settings.selectionColor = Color(.selectionRed)
//				settings.selectionOKColor = Color(.selectionGreen)
				game.setOrientation(landscape: isLandscape)
				numCols = game.cols
				numRows = game.rows
//				settings.fontStyle = .regular
//				for i in 0..<game.placedWords.count {
//					board.highlightWord(i, Int.random(in: 0...7))
//				}
//				game.board.highlightWord(0, 4)
//				game.board.highlightWord(1, 1)
//				game.board.highlightWord(5, 2)
				//game.board.highlightWord(10, 3)
//				print(game.board.words.words)
				placedSet = Set(game.board.wordPlacements.map({ $0.extended }))
				print("invert = \(invert), isLandscape = \(isLandscape)")
			}
			.gesture(
				DragGesture(minimumDistance: 5, coordinateSpace: .named("GridSpace"))
					.onChanged { value in
						processDrag(board: game.board, location: value.location, startLocation: value.startLocation, cellSize: cellSize, pad: padding)
					}
					.onEnded { _ in
						evaluateAndSaveWord(board: game.board)
					},
				isEnabled: allowDrag && !game.isOver
			)
			.overlay {
				if game.isOver && animateWin {
					WinnerView(game: game, width: width, points: settings.player.points, badges: game.badges)
				}
			}
	}
	
	private func capsuleView(board: GameBoard, cellSize: CGFloat, start: CellIndex, end: CellIndex, selected: Bool, padding: CGFloat, highlighted: Int = 0) -> some View {
		let startPoint = start.centerOfCell(cellSize: cellSize, spacing: spacing, offset: padding)
		let endPoint = end.centerOfCell(cellSize: cellSize, spacing: spacing, offset: padding)
		let fill = settings.highlight.isFill || selected
		let multi = settings.highlight.isColor
		let lineWidth = settings.highlight.isOutline || selected ? 3.0 : 0.0
		let fillColor = detectedWord != nil ? settings.selectionOKColor : settings.selectionColor
		let color = selected ? fillColor : settings.highlightColor
		let color2 = multi ? color : Color(.gray)
		let scale = selected ? 1.0 : 0.80
		let colorMix1 = color
		let lineColor = color2.opacity(0.5)
		let random = colors[highlighted].opacity(0.4)
		return Capsule()
			.fill(fill ? colorMix1 : (multi ? random : .clear))
			.stroke(lineColor, lineWidth: lineWidth)
			.frame(width: cellSize * scale, height: startPoint.distance(to: endPoint) + cellSize * scale)
			.rotationEffect(Angle(radians: startPoint.angle(to: endPoint)))
			.position(startPoint.midPoint(to: endPoint))
			.allowsHitTesting(false)
	}
	
	func isWordMatch(start: CellIndex?, end: CellIndex?) -> Bool {
		let activeWord = game.selectedWord
		guard !activeWord.isEmpty, let start, let end else { return false }
		let setElement1 = PlacedWord(word: activeWord, start: start).extended
		let setElement2 = PlacedWord(word: activeWord, start: end).extended
		if placedSet.contains(setElement1) || placedSet.contains(setElement2) {
			return true
		}
		return false
	}
	
	@ViewBuilder
	private func newGrid(board: GameBoard) -> some View {
		Grid(horizontalSpacing: 0, verticalSpacing: 0) {
			ForEach(0..<board.rows, id: \.self) { rowIndex in
				GridRow {
					ForEach(0..<board.cols, id: \.self) { columnIndex in
						ZStack {
							RoundedRectangle(cornerRadius: 0)
								.fill(.clear)
							Text(board[rowIndex, columnIndex].letter)
								.font(.system(size: cellSize * 0.7, weight: settings.fontStyle.weight))
								.minimumScaleFactor(0.5)
						}
						.aspectRatio(1, contentMode: .fit)
						.onGeometryChange(for: CGSize.self) { proxy in
							proxy.size
						} action: { newValue in
							let size = (newValue.height + newValue.width) * 0.5
							self.cellSize = size
							self.width = size * CGFloat(board.cols) * 0.8
							//print(newValue.width, newValue.height, size)
						}
					}
				}
			}
		}
		//.background(.pink.opacity(0.3))
		// 1. Force the grid to maintain a perfect 1:1 square ratio
		.aspectRatio(CGFloat(board.cols)/CGFloat(board.rows), contentMode: .fit)
		// 2. Expand strictly along the preferred axis based on orientation
		.frame(
			maxWidth: isLandscape ? nil : .infinity,
			maxHeight: isLandscape ? .infinity : nil
		)
		.ignoresSafeArea()
	}
	
	// MARK: - Word Evaluation Mechanics
	
	private func processDrag(board: GameBoard, location: CGPoint, startLocation: CGPoint, cellSize: CGFloat, pad: CGFloat) {
		let step = cellSize + CGFloat(spacing)
		let a = startLocation - pad
		let b = location - pad 
		let start = CellIndex.ifloor(a / step)
		
		guard start.inRange(row: 0..<numRows, column: 0..<numCols)
		else { return }
		
		if dragStartCell == nil {
			dragStartCell = CellIndex(row: start.row, col: start.col)
		}
		
		let current = CellIndex.ifloor(b / step)
		let bounded = current.limit(to: 0..<numRows, column: 0..<numCols)
		
		guard let origin = dragStartCell else { return }
		let delta = bounded - origin
		
		// Lock vector tracks and lock cell endpoints
		if delta.row == 0 && delta.col != 0 {
			// horizontal drag
			selectionDirection = delta.col > 0 ? .right : .left
			dragCurrentCell = CellIndex(row: origin.row, col: bounded.col)
		} else if delta.col == 0 && delta.row != 0 {
			// vertical drag
			selectionDirection = delta.row > 0 ? .down : .up
			dragCurrentCell = CellIndex(row: bounded.row, col: origin.col)
		} else if abs(delta.row) == abs(delta.col) && delta.row != 0 {
			// diagonal drag
			selectionDirection = delta.row == delta.col
				? (delta.col > 0 ? .diagonalDownRight : .diagonalUpLeft)
				: (delta.col < 0 ? .diagonalDownLeft : .diagonalUpRight)
			dragCurrentCell = CellIndex(row: bounded.row, col: bounded.col)
		}
		
		extractWordString(board: board)
	}
	
	private func extractWordString(board: GameBoard) {
		guard let start = dragStartCell, let end = dragCurrentCell, let selectionDirection else { return }
		
		var tempWord = ""
		var curr = start
		while true {
			tempWord.append(board[curr.row, curr.col].letter)
			if curr == end { break }
			curr = curr + selectionDirection
		}
		
		game.selectedWord = tempWord
	}
	
	// Helper to evaluate if the current selection forms a valid word
	private var detectedWord: String? {
		if isWordMatch(start: dragStartCell, end: dragCurrentCell) {
			return game.selectedWord
		}
		return nil
	}
	
	
	func removeActiveWord(colorIndex: Int) {
		//print(game.selectedWord, words)
		if let index = game.words.firstIndex(of: game.selectedWord.lowercased()) {
			game.board.highlightWord(index, colorIndex)
			game.selectedWord = ""
		}
	}
	
	private func evaluateAndSaveWord(board: GameBoard) {
		// Use computed property to evaluate forward vs reverse match
		if let targetWord = detectedWord {
			// Check to avoid duplicates
			if let _ = dragStartCell, let _ = dragCurrentCell {
				effect("success")
				removeActiveWord(colorIndex: colors.indices.randomElement()!)
				print("SUCCESS: Found Word \(targetWord.capitalized)")
			}
		} else {
			game.selectedWord = ""
			effect("oops")
		}
		
		if game.isOver {
			effect("victory-chime")
			game.timer.stop()
			dataContainer.unlockBadges(newGame: game)
			settings.player.updateTimes(level: game.level, interval: TimeInterval(game.timer.elapsedTime))
			game.save(to: game.name)
			settings.player.add(points: game.words.count)
			animateWin = true
		}
		
		// UI cleanup sequence
		withAnimation(.easeOut(duration: 0.15)) {
			dragStartCell = nil
			dragCurrentCell = nil
			selectionDirection = nil
		}
	}
	
	private func effect(_ sound: String) {
		if settings.soundsOn {
			SoundManager.shared.playSound(named: sound, type: "mp3", volume: Float(settings.soundVolume))
		}
	}
}

#Preview {
	@Previewable
	@State var game = Game(15, cols: 10, words: SampleWordLists.all[2])
	@Previewable @State var settings = SettingsType()
	LetterGridView(game: game, allowDrag: true, isLandscape: false, settings: $settings)
		.environment(DataContainer.sample20x20)
}
