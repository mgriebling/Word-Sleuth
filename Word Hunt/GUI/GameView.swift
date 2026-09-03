//
//  BoardView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 28.06.2026.
//

import SwiftUI

struct GameView: View {
	let game: Game
	
	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.scenePhase) var scenePhase
	
	@AppStorage(.settings) private var settings
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var showSettings = false
	@State private var showAwards = false
	@State private var toolbarID = UUID() // kludge to fix toolbar disappearing
	@State private var showWords = false
	
	#if os(iOS)
	typealias HSView = HStack
	typealias VSView = VStack
	#else
	typealias HSView = HSplitView
	typealias VSView = VSplitView
	#endif
	
	var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
	
	@State private var colors = [
		Color.red.opacity(0.5),
		Color(.systemBackground),
		.blue.opacity(0.5)
	]
	
	var body: some View {
		Group {
			if dataContainer.isLandscape {
				landscapeView()
			} else {
				portraitView()
			}
		}
		.sheet(isPresented: $showAwards) {
			AchievementsView()
		}
		.sheet(isPresented: $showSettings) {
			SettingsView()
				.navigationTitle("Settings")
		}
		.toolbar { toolBar(isLandscape: dataContainer.isLandscape) }
		.onChange(of: scenePhase) { oldValue, newValue in
			if newValue == .active {
				toolbarID = UUID()   // trigger toolbar update
			}
		}
//		#if os(ios)
		.navigationTitle("")
		.navigationBarTitleDisplayMode(.inline)
//		#endif
	}
	
	@ViewBuilder
	private func landscapeWordList() -> some View {
		WordView(words: game.board.wordPlacements,
				 maxWordLength: game.board.words.maxLength)
			.frame(width: isPhone && game.rows > 16 ? 150 : nil)
	}
	
	private func landscapeView() -> some View {
		// landscape mode
		HSView {
			if settings.horizontal == .left {
				landscapeWordList()
				divider()
			}
			
			LetterGridView(game: game, allowDrag: true, isLandscape: true, settings: $settings)
				.layoutPriority(1)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			if settings.horizontal == .right {
				divider()
				landscapeWordList()
			}
		}
		.background(
			LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
		)
	}
	
	@ViewBuilder
	private func portraitView() -> some View {
		// portrait mode
		VSView {
			portraitWordList()
			
			LetterGridView(game: game, allowDrag: true, isLandscape: false, settings: $settings)
				.layoutPriority(1)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.onAppear {
					if !showWords, game.rows < 18 {
						showWords = true
					}
				}
			Spacer()
		}
		.padding(.horizontal)
		.background(
			LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
		)
	}
	
	@ViewBuilder
	func portraitWordList() -> some View {
		let wordList = WordView(words: game.board.wordPlacements, maxWordLength: game.board.words.maxLength)
		var listHeight: CGFloat {
			showWords ? 300 / max(2, CGFloat(game.rows - 12)) + 100 : 0
		}
		wordList
			.frame(maxWidth: .infinity, maxHeight: isPhone ? listHeight : nil)
			.opacity(showWords ? 1 : 0)
			//.background(.blue)
		divider()
	}
	
	@ToolbarContentBuilder
	func toolBar(isLandscape: Bool) -> some ToolbarContent {
		let titleItem = ToolbarItem(placement: .topBarLeading) {
			if isLandscape || !isPhone {
				Text(game.name + " Puzzle")
					.allowsTightening(true)
					.fixedSize(horizontal: true, vertical: false)
					.foregroundStyle(.secondary)
			} else {
				if isPhone {
					Button {
						withAnimation {
							showWords.toggle()
						}
					} label: {
						HStack {
							if horizontalSizeClass == .regular {
								Text("Words")
							}
							Image(systemName: "arrow.right")
								.rotationEffect(Angle(degrees: showWords ? 90 : 0))
						}
					}
				} else {
					Text(game.name)
						.allowsTightening(true)
						.lineLimit(1)
						.frame(width: 130)
						.foregroundStyle(.secondary)
				}
			}
		}
		let settingsButton = Button(action: { showSettings = true } ) {
			Label("Settings", systemImage: "gearshape")
				.foregroundStyle(.secondary)
		}
		let winButton = Button(action: { showAwards = true } ) {
			Text("\(Image(systemName: game.badges.isEmpty ? "fireworks" : "medal"))")
				.foregroundStyle(colorScheme == .dark ? .yellow : .red)
		}
		
		ToolbarItemGroup(placement: .principal) { // macOS uses .status
			ViewThatFits(in: .horizontal) {
				if !isPhone || isLandscape {
					HStack {
						if game.isOver {
							winButton
						} else {
							Text("Found: \(game.matched) of \(game.placedWords.count)")
						}
						ElapsedTime(text: "Time:", timer: game.timer)
							.lineLimit(1)
							.fixedSize(horizontal: true, vertical: false)
							.fontDesign(.monospaced)
					}
				}
				HStack {
					if game.isOver {
						winButton
					} else {
						Text("\(game.matched) / \(game.placedWords.count)")
					}
					ElapsedTime(text: "", timer: game.timer)
						.lineLimit(1)
						.fixedSize(horizontal: true, vertical: false)
						.fontDesign(.monospaced)
				}

			}
			.id(toolbarID)
			.foregroundStyle(.secondary)
		}
		
		titleItem
		
		ToolbarItemGroup(placement: .primaryAction) {
			Button(action: highlightWord) {
				Image(systemName: "lightbulb")
			}
			.disabled(game.isOver)
			if horizontalSizeClass != .compact {
				settingsButton
			}
			GameMenuView(game: game, isInDetail: true)
		}
	}
		
	@ViewBuilder
	func title (name: String, isLandscape: Bool) -> some View {
		if isLandscape || !isPhone {
			Text(name + " Puzzle")
				.allowsTightening(true)
				.fixedSize(horizontal: true, vertical: false)
				.foregroundStyle(.secondary)
		} else {
			Text(name)
				.allowsTightening(true)
				.foregroundStyle(.secondary)
		}
	}
	
	/// Show a hint by momentarily highlighting a random word
	private func highlightWord() {
		let unselected = game.board.wordPlacements.filter { !$0.highlighted }
		let word = unselected.randomElement()!
		let index = game.board.wordPlacements.firstIndex(of: word)!
		settings.player.add(points: -5)
		Task {
			withAnimation {
				game.board.highlightWord(index)
			}
			try? await Task.sleep(for: .seconds(2))
			withAnimation {
				game.board.unhighlightWord(index)
			}
		}
	}
	
	/// the custom styled dividing line block by Google AI
	func divider() -> some View {
		#if os(macOS)
		Group {
			Rectangle()
				// Changes color dynamically when the cursor hovers over the area
				.fill(isHovering ? Color.accentColor : Color(.separatorColor))
				.frame(width: isHovering ? 3 : 1)
				.animation(.easeOut(duration: 0.1), value: isHovering)
		}
		// Strict sizing so this "middle pane" acts as a slim dividing bar
		.frame(width: 8)
		.contentShape(Rectangle()) // Expands hover asset detection region
		.onHover { inside in
			isHovering = inside
			if inside {
				NSCursor.resizeLeftRight.push()
			} else {
				NSCursor.pop()
			}
		}
		#else
		Spacer()
		#endif
	}
}

#Preview {
	@Previewable
	@State var game = Game(16, cols: 12, words: SampleWordLists.all[0])
	NavigationStack {
		GameView(game: game)
			.environment(DataContainer())
	}
}

