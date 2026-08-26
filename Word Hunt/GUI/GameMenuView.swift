//
//  GameMenu.swift
//  Word Hunt
//
//  Created by Michael Griebling on 23.08.2026.
//
import SwiftUI

struct GameMenuView: View {
	let game: Game?
	var isInDetail: Bool = false
	
	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	@Environment(DataContainer.self) private var dataContainer
	
	@State private var showSettings = false
	@State private var showAwards = false
	@State private var showAbout = false
	@State private var isShowingDeleteConfirmation = false
	@State private var showAdvancedCreate = false
	
	var body: some View {
		let settingsButton = Button(action: { showSettings = true } ) {
			Label("Settings", systemImage: "gearshape")
		}
		Menu {
			if horizontalSizeClass == .compact {
				settingsButton
			}
			if let game {
				ShareLink(item: game.url(name: game.name))
			}
			if !isInDetail {
				FileImportButton(name: "Import Puzzle")
				Button(action: { showAdvancedCreate = true }) {
					Label("Create Games (Pro)", systemImage: "square.grid.4x3.fill")
				}
			}
			Divider()
			Button(action: { showAwards = true }) {
				Label("My Awards", systemImage: "medal")
			}
			Button(action: { showAbout = true }) {
				Label("About Word Sleuth", systemImage: "info.circle")
			}
			Divider()
			Section("Advanced") {
				Button(action: { isShowingDeleteConfirmation = true } ) {
					Label("Delete All", systemImage: "trash")
				}
				.disabled(dataContainer.games.isEmpty)
			}
		} label: {
			Image(systemName: "ellipsis")
		}
		.sheet(isPresented: $showAbout) {
			AboutView()
		}
		.sheet(isPresented: $showAwards) {
			AchievementsView()
		}
		.sheet(isPresented: $showSettings) {
			SettingsView()
				.navigationTitle("Settings")
		}
		.sheet(isPresented: $showAdvancedCreate) {
			GameCreationView()
		}
		.confirmationDialog("Discard \(dataContainer.games.count) Puzzles", isPresented: $isShowingDeleteConfirmation) {
			Button("Discard ALL \(dataContainer.games.count) Puzzles", role: .destructive) {
				withAnimation {
					dataContainer.games.indices.forEach { index in
						let game = dataContainer.games[index]
						game.delete()
					}
					dataContainer.games = []
				}
			}
			Button("Cancel") { }
		} message: {
			Text("Puzzles will be permanently deleted. Earned badges are not removed.")
		}
	}
}
