//
//  WordListSummary.swift
//  Word Hunt
//
//  Created by Michael Griebling on 23.06.2026.
//

import SwiftUI

struct GameSummary: View {
	let game: Game
	
	@State private var width: CGFloat = 200
	@State private var showWords = false
	
	@AppStorage(.settings) private var settings

	var body: some View {
		VStack(alignment: .leading) {
			Text("\(game.board.words.name) Puzzle").font(.title2).bold()
			Text("Created: ") +
			Text(game.creationDate.formatted(.relative(presentation: .named, unitsStyle: .wide)).capitalized)
			if game.matched > 0 {
				Text("Matched: \(game.matched) of \(game.placedWords.count) words")
			}
			if game.timer.elapsedTime > 0 {
				ElapsedTime(text: "Elapsed Time: ", timer: game.timer)
			}
			Text("Level: \(game.level) (\(game.rows) ⨉ \(game.cols))")
				.frame(maxWidth: .infinity, alignment: .leading)
			Text("Words: \(Image(systemName: showWords ? "arrow.down" : "arrow.right"))")
				.foregroundStyle(Color.accentColor)
				.highPriorityGesture(
					TapGesture(count: 1)
						.onEnded {
							withAnimation {
								showWords.toggle()
							}
						}
				)
			if showWords {
				WordView(words: game.placedWords, style: .paragraph)
			}
		}
		.onGeometryChange(for: CGFloat.self) { proxy in
			proxy.size.width
		} action: { width in
			self.width = width
			// print("Width = \(self.width)")
		}
		.overlay {
			if game.isOver {
				WinnerView(game: game, width: max(width, 275) * 0.6,
						   points: settings.player.points,
						   badges: game.badges,
						   animation: false)
			}
		}
	}
}

#Preview {
	@Previewable
	@State var game = Game(size: 20, words: SampleWordLists.all[0])
	GameSummary(game: game)
		.onAppear {
//			for i in game.board.wordPlacements.indices.dropLast() {
//				game.board.highlightWord(i)
//			}
			game.board.highlightWord(0)
			game.board.highlightWord(5)
			game.board.highlightWord(game.board.wordPlacements.indices.last!)
		}
}
