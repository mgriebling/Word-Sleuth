//
//  SettingsView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 01.07.2026.
//

import SwiftUI

struct SettingsView: View {
	
	@AppStorage(.settings) private var settings
	
	// Word for the demo grid to show selection/hightling
	static let words = WordList(words: ["Test", "High", "Push", "Unit"])
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	@State private var internalSettings = SettingsType()
	@State private var game = Game(size: SettingsType.maxColRange.lowerBound, words: words)
	@State private var creationMode: CreationMode = .oneGame
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Game Creation Defaults (\(Image(systemName: "plus")) Touched)") {
					HStack {
						Text("Games:")
						Picker("Create Game:", selection: $creationMode.animation()) {
							ForEach(CreationMode.allCases.dropLast(), id:\.self) { mode in
								Text("\(mode.rawValue)").tag(mode)
							}
							Image(systemName: "ellipsis")
								.tag(CreationMode.custom)
						}
						.onChange(of: creationMode) {
							if creationMode != .custom {
								internalSettings.gameNumber = creationMode.number
							} else {
								internalSettings.gameNumber = 6
							}
						}
						.pickerStyle(.segmented)
					}
					
					if creationMode == .custom {
						HStack {
							Text("Games: \(internalSettings.gameNumber) ")
							Slider(value: Binding(
								get: { Double(internalSettings.gameNumber) },
								set: { internalSettings.gameNumber = Int($0) }
							), in: 6...20)
						}
					}
			
					HStack {
						Text("Level:")
						Picker("Level:", selection: $internalSettings.level) {
							ForEach(Level.allCases.dropFirst(), id:\.self) { level in
								Text("\(level.rawValue)").tag(level)
							}
						}
						.pickerStyle(.segmented)
					}
				}
				
				Section("Word Selection") {
					Toggle("Allow Reverse Selection", isOn: $internalSettings.allowReverseSelection)
				}
	
				Section("Word List") {
					HStack {
						Text("Position relative to letter grid")
						Picker("Horizontal", selection: $internalSettings.horizontal) {
							Image(systemName: "arrow.left.to.line")
								.tag(Horizontal.left)
							Image(systemName: "arrow.right.to.line")
								.tag(Horizontal.right)
						}
						.pickerStyle(.segmented)
					}
					
					Toggle("Sorted Across Columns", isOn: $internalSettings.sortAcrossCols)
				}
				
				Section("Timer") {
					Toggle("Enable", isOn: $internalSettings.showTimer)
				}
				
				Section("Sound Effects") {
					Toggle("Enable", isOn: $internalSettings.soundsOn)
						.onChange(of: internalSettings.soundsOn) {
							if internalSettings.soundsOn {
								play(sound: "success", volume: internalSettings.soundVolume)
							}
						}
					if internalSettings.soundsOn {
						HStack {
							Text("Volume:")
							Text("\(Int(internalSettings.soundVolume * 100))%")
							Slider(value: $internalSettings.soundVolume, in: 0.0...1.0) {
								Text("Sound Volume")
							} minimumValueLabel: {
								Image(systemName: "speaker")
							} maximumValueLabel: {
								Image(systemName: "speaker.wave.3")
							} onEditingChanged: { editing in
								if !editing {
									play(sound: "success", volume: internalSettings.soundVolume)
								}
							}
						}
					}
				}
				
				Section("Grid Appearance") {
					Picker("Selection", selection: $internalSettings.highlight) {
						ForEach(HighLight.allCases) { mode in
							Image(systemName: mode.image)
								.symbolRenderingMode(.palette)
								.foregroundStyle(.blue, .yellow, .red)
						}
					}
					.pickerStyle(.segmented)
					
					HStack {
						Text("Font Weight:")
						Picker("Weight:", selection: $internalSettings.fontStyle) {
							ForEach(FontStyle.allCases, id:\.self) { level in
								Text("\(level.rawValue)").tag(level)
							}
						}
						.pickerStyle(.segmented)
					}
					
					HStack {
						Spacer()
						LetterGridView(game: game, allowDrag: true, settings: $internalSettings).id(UUID())
							.frame(maxWidth: 300, maxHeight: 300)
							.onAppear {
								game.board.highlightWord(0, 1)
								game.board.highlightWord(1, 3)
							}
						Spacer()
					}
					
					ColorPicker("Selection Color", selection: $internalSettings.selectionColor, supportsOpacity: false)
					ColorPicker("Selection OK Color", selection: $internalSettings.selectionOKColor, supportsOpacity: false)
					if internalSettings.highlight.isFill {
						ColorPicker("Highlight Color", selection: $internalSettings.highlightColor, supportsOpacity: false)
					}
				}
			}
			.onAppear {
				internalSettings = settings
			}
#if os(macOS)
			.padding()
			.frame(width: 450, height: 700)
#else
			.navigationBarTitle("Settings")
			.navigationBarTitleDisplayMode(.inline)
#endif
			.toolbar {
				EditToolbar() {
					settings = internalSettings
					dismiss()
				} 
			}
		}
	}
	
	private func play(sound: String, volume: Double) {
		SoundManager.shared.playSound(named: sound, type: "mp3", volume: Float(settings.soundVolume))
	}
}

#Preview {
	SettingsView()
		.environment(DataContainer.sample20x20)
}
