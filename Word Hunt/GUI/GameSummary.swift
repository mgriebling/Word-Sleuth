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
			HStack {
				Text("Words: ")
				Image(systemName: "arrow.right")
					.rotationEffect(Angle(degrees: showWords ? 90 : 0))
			}
			.highPriorityGesture(
				TapGesture(count: 1)
					.onEnded {
						withAnimation(.easeInOut(duration: 0.3)) {
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
		}
		.overlay {
			if game.isOver {
				VStack(alignment: .trailing) {
					HStack(alignment: .center) {
						Spacer()
						ForEach(game.badges) { badge in
							Image(badge.details.image)
								.resizable()
								.aspectRatio(1, contentMode: .fit)
								.frame(width: 75, height: 75)
						}
					}
				}
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
