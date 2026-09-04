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
	@State private var showingText = true
	@State private var selectedWord = ""
	
	#if os(iOS)
	typealias HSView = HStack
	typealias VSView = VStack
	#else
	typealias HSView = HSplitView
	typealias VSView = VSplitView
	#endif
	
	var isPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
	
	@State private var colors = [
		Color.red.opacity(0.4),
		Color(.systemBackground),
		.blue.opacity(0.4)
	]
	
	var body: some View {
		Group {
			if dataContainer.isLandscape {
				landscapeView()
			} else {
				portraitView()
			}
			
//			// Places floating word selection near the top
//			if dataContainer.isLandscape {
//				VStack {
//					HStack {
//						FloatingWord(activeWord: $selectedWord)
//							.padding(.leading, 100)
//						Spacer()
//					}
//					Spacer()
//				}
//			} else {
//				VStack {
//					FloatingWord(activeWord: $selectedWord)
//					Spacer()
//				}
//			}
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
		.navigationTitle(Text(verbatim: ""))
		.navigationBarTitleDisplayMode(.inline)
//		#endif
	}
	
	@ViewBuilder
	private func landscapeWordList() -> some View {
		ZStack {
			WordView(words: game.board.wordPlacements,
					 maxWordLength: game.board.words.maxLength)
			.frame(maxWidth: isPhone && game.rows > 16 ? 150 : 300, maxHeight: .infinity)
			
			VStack {
				FloatingWord(activeWord: $selectedWord)
				Spacer()
			}
		}
	}
	
	private func landscapeView() -> some View {
		// landscape mode
		HSView {
			if settings.horizontal == .left {
				landscapeWordList()
				divider()
			}
			
			LetterGridView(game: game, allowDrag: true, isLandscape: true, selectedWord: $selectedWord, settings: $settings)
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
			
			LetterGridView(game: game, allowDrag: true, isLandscape: false, selectedWord: $selectedWord, settings: $settings)
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
			showWords || !isPhone ? 300 / max(2, CGFloat(game.rows - 12)) + 100 : 0
		}
		ZStack {
			VStack {
				wordList
					.frame(maxWidth: .infinity, maxHeight: listHeight)
					.opacity(showWords || !isPhone ? 1 : 0)
				divider()
			}
			
			VStack {
				FloatingWord(activeWord: $selectedWord)
				Spacer()
			}
		}
	}
	
	@ToolbarContentBuilder
	func toolBar(isLandscape: Bool) -> some ToolbarContent {
		let titleItem = ToolbarItem(placement: .topBarLeading) {
			if isLandscape || !isPhone {
				Text(game.name + " Puzzle")
					.allowsTightening(true)
					.fixedSize(horizontal: true, vertical: false)
					.foregroundStyle(Color(.systemCyan))
			} else {
				if isPhone {
					Button {
						withAnimation { showWords.toggle() 	}
					} label: {
						HStack(spacing: 0) {
							Image(systemName: "text.justify")
							Image(systemName: "arrow.right")
								.rotationEffect(Angle(degrees: showWords ? 90 : 0))
						}
					}
				} else {
					Text(game.name)
						.allowsTightening(true)
						.lineLimit(1)
						.frame(width: 130)
						.foregroundStyle(Color(.systemCyan))
				}
			}
		}
		let settingsButton = Button(action: { showSettings = true } ) {
			Label("Settings", systemImage: "gearshape")
				.foregroundStyle(Color(.systemCyan))
		}
		let winButton = Button(action: { showAwards = true } ) {
			Image(systemName: game.badges.isEmpty ? "fireworks" : "medal")
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
							.allowsTightening(true)
							.lineLimit(1)
							.fixedSize(horizontal: true, vertical: false)
					}
					ElapsedTime(text: "", timer: game.timer)
						.lineLimit(1)
						.fixedSize(horizontal: true, vertical: false)
						.fontDesign(.monospaced)
				}

			}
			.id(toolbarID)
			.foregroundStyle(Color(.systemCyan))
		}
		
		if #available(iOS 26.0, *) {
			titleItem
				.sharedBackgroundVisibility(!isPhone || isLandscape ? .hidden : .automatic)
		} else {
			titleItem  // Fallback on earlier versions
		}
		
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
				.foregroundStyle(Color(.systemCyan))
		} else {
			Text(name)
				.allowsTightening(true)
				.foregroundStyle(Color(.systemCyan))
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

