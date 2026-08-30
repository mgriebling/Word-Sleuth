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
	
	@AppStorage(.settings) private var settings
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var showSettings = false
	@State private var showAwards = false
	
	#if os(iOS)
	typealias HSView = HStack
	typealias VSView = VStack
	#else
	typealias HSView = HSplitView
	typealias VSView = VSplitView
	#endif
	
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
//		#if os(ios)
		.navigationTitle("")
		.navigationBarTitleDisplayMode(.inline)
//		#endif
	}
	
	private func landscapeView() -> some View {
		// landscape mode
		HSView {
			if settings.horizontal == .left {
				wordsList()
				divider()
			}
			
			LetterGridView(game: game, allowDrag: true, isLandscape: true, settings: $settings)
				.layoutPriority(1)
			
			if settings.horizontal == .right {
				divider()
				wordsList()
			}
		}
		.background(
			LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
		)
	}
	
	private func portraitView() -> some View {
		// portrait mode
		VSView {
			wordsList()
			divider()
			
			LetterGridView(game: game, allowDrag: true, isLandscape: false, settings: $settings)
				.layoutPriority(1)
			Spacer()
		}
		.padding(.horizontal)
		.background(
			LinearGradient(colors: colors, startPoint: .bottom, endPoint: .top)
		)
	}
	
	func wordsList() -> some View {
		ZStack {
			WordView(words: game.board.wordPlacements, maxWordLength: game.board.words.maxLength)
			floatingWord(game.selectedWord)
				.frame(maxWidth: 400)
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
	
	@ToolbarContentBuilder
	func toolBar(isLandscape: Bool) -> some ToolbarContent {
		let titleItem = ToolbarItem(placement: .topBarLeading) {
			title(name: game.name, isLandscape: isLandscape)
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
			.foregroundStyle(.secondary)
		}
		if #available(iOS 26.0, *) {
			titleItem
			.sharedBackgroundVisibility(.hidden)
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
		if isLandscape || UIDevice.current.userInterfaceIdiom != .phone {
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
	
	/// Floating selected name
	@ViewBuilder
	private func floatingWord(_ activeWord: String) -> some View {
		let cellSize: CGFloat = 30
		let grey = Color(.systemGray4)
		let frameWidth = activeWord.count/2 + 1
		Text(activeWord)
			.font(.system(size: cellSize * 0.8, weight: .bold))
			.lineLimit(1)
			.minimumScaleFactor(0.75)
			.allowsTightening(true)
			.fixedSize(horizontal: true, vertical: false)
			.frame(width: cellSize * CGFloat(frameWidth), height: cellSize)
			.padding(10)
			.background(grey)
			.cornerRadius(15)
			.zIndex(10)
			.opacity(activeWord.isEmpty ? 0.0 : 1.0)
			.animation(.none, value: frameWidth)
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
}

#Preview {
	@Previewable
	@State var game = Game(20, cols: 20, words: SampleWordLists.all[0])
	NavigationStack {
		GameView(game: game)
			.environment(DataContainer())
	}
}

