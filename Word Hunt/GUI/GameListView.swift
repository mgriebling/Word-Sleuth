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
	
	enum Filter : String, CaseIterable, Identifiable {
		case all, recent, active, new
		
		var id: Filter { return self }
	}
	
	// MARK: Data Owned by me
	@State private var showGameEditor = false
	@State private var showOptions = false
	@State private var isShowingDeleteConfirmation = false
	@State private var filter = Filter.all
	@State private var showWins = true
	@State private var prevSelection: Game?
	
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
			HStack {
				Picker("Filter By:", selection: $filter.animation()) {
					ForEach(Filter.allCases, id: \.self) { mode in
						Text("\(mode.rawValue.capitalized)").tag(mode)
					}
				}
				.pickerStyle(.segmented)
				
				Button(action: { withAnimation { showWins.toggle() }}) {
					MedalIcon(noMedal: showWins, scaling: 0.25)
				}
				.tint(Color.primary)
				.padding(.trailing, 2)
				.buttonBorderShape(.capsule)
				.buttonStyle(.bordered)
				.disabled(filter == .new || filter == .active)
			}
			List(selection: $selection) {
				ForEach(filteredSorted) { game in
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
					.swipeActions(edge: .leading, allowsFullSwipe: false) {
						ShareLink(item: game.url(name: game.name))
							.tint(Color(.systemBlue))
						Button(action: {} ) {
							Label("Save Puzzle", systemImage: "arrow.down.doc")
						}
						.tint(Color(.systemGreen))
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
			}
			.navigationTitle("Puzzles")
			.navigationBarTitleDisplayMode(.inline)
			.onAppear {
				if selection == nil {
					print("Nothing selected")
				} else {
					print("Selected: \(selection!.name)")
				}
			}
			.listStyle(.plain)
			.onChange(of: selection) { prev, current in
				prevSelection = prev
				if let prev = prevSelection, selection == nil {
					print("Previous game = \(prev.name)")
					prev.timer.handleViewDisappearing()
				}
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
	
	var filteredSorted: [Game] {
		var filtered: [Game]
		switch filter {
			case .recent:
				filtered = dataContainer.games.filter {
					showWins ? $0.isRecent : $0.isRecent && !$0.isOver
				}
			case .new:
				filtered = dataContainer.games.filter {
					showWins ? $0.timer.elapsedTime == 0
						     : $0.timer.elapsedTime == 0 && !$0.isOver
				}
			case .active:
				filtered = dataContainer.games.filter {
					!$0.isOver && $0.timer.elapsedTime > 0
				}
			default:
				filtered = dataContainer.games.filter {
					showWins ? true : !$0.isOver
				}
		}
		switch settings.sortPuzzles {
			case .date:
				return filtered.sorted {
					settings.sortIncreasing ? $0.creationDate < $1.creationDate : $0.creationDate > $1.creationDate
				}
			case .name:
				return filtered.sorted {
					settings.sortIncreasing ? $0.name < $1.name : $0.name > $1.name
				}
			case .level:
				return filtered.sorted {
					settings.sortIncreasing ? $0.level < $1.level : $0.level > $1.level
				}
//			default:
//				return filtered
		}
	}
	
	var addButton: some View {
		Button("Add Game", systemImage: "plus") {
			let number = settings.gameNumber
			let sizes = Array(repeating: settings.level.size, count: number)
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
