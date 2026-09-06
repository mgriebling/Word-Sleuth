//
//  WordHunt.swift
//  Word Hunt
//
//  Created by Mike Griebling on 2022-11-06.
//

import SwiftUI

@main
struct WordHunt: App {
	
	let dataContainer = DataContainer()
	
	@Environment(\.openURL) private var openURL
	
	// State variable to control the visibility of the About screen sheet
	@State private var showAboutWindow = false
	
	let name = "Word Sleuth"
	
	var body: some Scene {
		WindowGroup {
			MainAppView()
				.environment(dataContainer)
				// Listen for state changes to display your About view as a sheet
				.sheet(isPresented: $showAboutWindow) {
					AboutView()
				}
//				.onOpenURL { url in
//					print("Opening Word Sleuth puzzle: \(url)")
//				}
		}
		.commands {
			CommandGroup(replacing: .appInfo) {
				Button("About \(name)") {
					showAboutWindow = true
				}
				// Optional: Provide a native keyboard shortcut (e.g., Command + I)
//				.keyboardShortcut("i", modifiers: .command)
			}
			
			// Replaces the system Help menu items
			CommandGroup(replacing: .help) {
				Button("\(name) User Guide") {
					if let url = URL(string: "https://zenadesign.org") {
						openURL(url)
					}
				}
				.keyboardShortcut("?", modifiers: [.command]) // Standard help shortcut
				
				Button("Contact Support") {
					if let url = URL(string: "mailto:support@zenadesign.org") {
						openURL(url)
					}
				}
			}
		}
#if os(macOS)
		Settings {
			SettingsView()
		}
#endif
		
	}
}

