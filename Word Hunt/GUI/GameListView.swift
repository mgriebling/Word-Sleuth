//
//  GameList.swift
//  Word Hunt
//
//  Created by Michael Griebling on 27.06.2026.
//

import SwiftUI

struct GameListView: View {
	// MARK: Data shared with me
	@Binding var selection: Game?

	@Environment(DataContainer.self) private var dataContainer
	
	@AppStorage(.settings) private var settings
	
	// MARK: Data Owned by me
	// @State private var gameToEdit: Game?
	@State private var showGameEditor = false
	@State private var showOptions = false
	@State private var isShowingDeleteConfirmation = false
	
    var body: some View {
		let colors = [Color.red.opacity(0.5), Color.red.opacity(0.2)]
		if dataContainer.games.isEmpty {
			ContentUnavailableView {
				Label("No puzzles created yet!", systemImage: "exclamationmark.circle")
			} description: {
				Text("Touch \(Image(systemName: "plus")) at the top right to get started.")
			}
			.toolbar {
				addButton
				GameMenuView(game: nil)
			}
		} else {
			List(selection: $selection) {
				ForEach(dataContainer.games) { game in
					NavigationLink(value: game) {
						GameSummary(game: game)
							.tag(game)
					}
					.selectionDisabled(true)
					.foregroundStyle(Color.primary)
					.listRowBackground(
						RoundedRectangle(cornerRadius: 20)
							.fill(
								selection == game ? LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top) : LinearGradient(colors: [.clear, .clear], startPoint: .bottom, endPoint: .top)
							)
					)
					.contextMenu {
						ShareLink(item: game.url(name: game.name))
						Button(action: {} ) {
							Label("Save Puzzle", systemImage: "arrow.down.doc")
						}
					}
				}
				.onDelete { indexSet in
					withAnimation {
						indexSet.forEach { index in
							let game = dataContainer.games.remove(at: index)
							game.delete()
						}
					}
				}
				.onMove { offsets, destination in
					withAnimation {
						dataContainer.games.move(fromOffsets: offsets, toOffset: destination)
					}
				}
			}
			.onAppear {
				if selection == nil {
					print("Nothing selected")
				} else {
					print("Selected: \(selection!.name)")
				}
			}
			.listStyle(.sidebar)
			.onChange(of: selection) {
				if let selection, !dataContainer.games.contains(selection) {
					self.selection = nil
					print("Setting selection to nil")
				}
			}
			.toolbar {
				addButton
				GameMenuView(game: selection)
			}
		}
    }
	
	var addButton: some View {
		Button("Add Game", systemImage: "plus") {
			let number = settings.gameNumber
			let sizes = Array(repeating: settings.difficulty.size, count: number)
			dataContainer.createGames(number: number, sizes: sizes)
			self.selection = dataContainer.games.first
		}
	}
}

#Preview {
	@Previewable @State var selection: Game?
	@Previewable @State var games: [Game] = [
		Game(size: 14, words: SampleWordLists.all[0])
	]
	NavigationStack {
		GameListView(selection: $selection)
			.environment(DataContainer())
	}
}
