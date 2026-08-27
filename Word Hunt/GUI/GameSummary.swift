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
	
	@AppStorage(.settings) private var settings
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("\(game.board.words.name) Puzzle").font(.title2).bold()
			Text("Size: \(game.rows) ⨉ \(game.cols)")
			Text("Matched: \(game.matched) of \(game.placedWords.count) words")
			ElapsedTime(text: "Time: ", timer: game.timer)
			Text("Difficulty: \(game.level)")
			WordView(words: game.placedWords, style: .paragraph)
					.lineLimit(2)
					.frame(maxWidth: .infinity)
		}
		.onGeometryChange(for: CGFloat.self) { proxy in
			proxy.size.width
		} action: { width in
			self.width = width
			print("Width = \(self.width)")
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
