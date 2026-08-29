import SwiftUI

struct MainAppView: View {
	// Track the currently active tab
	@State private var activeTab = Tabs.puzzle
	@State private var selectedPuzzle: Game?
	@State private var selectedWords: WordList?
	
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var puzzlesExpanded: Bool = true
	@State private var wordsExpanded: Bool = false
	@State private var showDetail: Bool = true
	@State private var columnVisibility: NavigationSplitViewVisibility = .all
	
	var body: some View {
		GeometryReader { geometry in
			Group {
				if showDetail {
					baseSplitview()
						.navigationSplitViewStyle(.prominentDetail)
				} else {
					baseSplitview()
						.navigationSplitViewStyle(.automatic)
				}
			}
			.onChange(of: geometry.size) {
				withAnimation {
					dataContainer.isLandscape = geometry.size.width > geometry.size.height
				}
				// print("Top Size = \(geometry.size.width) x \(geometry.size.height)")
			}
			.onChange(of: activeTab, showDetailOrAll)
			.onChange(of: selectedPuzzle, showDetailOnly)
			.focusEffectDisabled(true)
			.onAppear(perform: { initialize(size: geometry.size) } )
		}
	}
	
	private func showDetailOrAll() {
		if activeTab == .puzzle {
			showDetailOnly()
		} else {
			withAnimation {
				columnVisibility = .all
				showDetail = false
			}
		}
	}
	
	private func showDetailOnly() {
		withAnimation {
			columnVisibility = .detailOnly
			showDetail = true
		}
	}
	
	private func baseSplitview() -> some View {
		NavigationSplitView(columnVisibility: $columnVisibility) {
			sidebarView()
		} detail: {
			detailView()
		}
	}
	
	private func detailView() -> some View {
		Group {
			switch activeTab {
				case .puzzles:
					if let game = selectedPuzzle {
						GameView(game: game)
							.id(selectedPuzzle)
							.onTapGesture {
								columnVisibility = .detailOnly
							}
					} else {
						blankView(for: activeTab)
					}
				case .words:
					if let _ = selectedWords {
						WordsEditor(words: $selectedWords)
							.id(selectedWords)
					} else {
						blankView(for: activeTab)
					}
			}
		}
	}
	
	private func initialize(size: CGSize) {
		// print("Init Size = \(size.width) x \(size.height)")
		withAnimation {
			dataContainer.isLandscape = size.width > size.height
			selectedPuzzle = dataContainer.games.first
			selectedWords = dataContainer.wordLists.first
			activeTab = .puzzles(selectedPuzzle)
			columnVisibility = .detailOnly
		}
	}
	
	private func sidebarView() -> some View {
		Group {
			switch activeTab {
				case .puzzles:
					GameListView(selection: $selectedPuzzle)
					.onAppear {
						if selectedPuzzle == nil {
							print("No selected puzzle")
						}
					}
				case .words:
					WordListView(selection: $selectedWords)
			}
		}
		.toolbar {
			tabToolbar()
		}
	}
	
	@ToolbarContentBuilder
	private func tabToolbar() -> some ToolbarContent {
		ToolbarItem(placement: .principal) {
			Picker("Tabs", selection: $activeTab) {
				Text(Tabs.puzzle.name)
					.tag(Tabs.puzzle)
				Text(Tabs.wordList.name)
					.tag(Tabs.wordList)
			}
			.pickerStyle(.segmented)
			.fixedSize()
		}
	}

	@ViewBuilder
	private func blankView(for category: Tabs?) -> some View {
		let name = category?.name ?? "item"
		ContentUnavailableView {
			Label("No \(name) selected yet!", systemImage: "exclamationmark.circle")
		} description: {
			Text("Select a \(name) on the left to get started.")
		}
	}
}

enum Tabs: Hashable {
	case puzzles(Game?)
	case words(WordList?)
	
	static var puzzle: Self { .puzzles(nil) }
	static var wordList: Self { .words(nil) }
	
	var name: String {
		switch self {
			case .puzzles: "Puzzles"
			case .words: "Words"
		}
	}
	
	var image: String {
		switch self {
			case .puzzles: "rectangle.and.text.magnifyingglass"
			case .words: "long.text.page.and.pencil.fill"
		}
	}
}

// MARK: - Preview
#Preview {
	MainAppView()
		.environment(DataContainer(loadSampleGames: true))
}
