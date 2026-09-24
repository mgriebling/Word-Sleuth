//
//  GameImportButton.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 24.06.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI
import UniformTypeIdentifiers

struct GameImportButton: View {
	let name: String

	@Environment(DataContainer.self) private var dataContainer
	
	@State private var isImporting = false

	var body: some View {
		Button(action: { isImporting = true }) {
			Label(name, systemImage: "square.and.arrow.down")
		}
		.fileImporter(
			isPresented: $isImporting,
			allowedContentTypes: [.data] // Change to [.pdf], [.image], etc. as needed
		) { result in
			switch result {
				case .success(let file):
					print("Imported file: \(file.absoluteString)")
					if let game = Game(from: file) {
						dataContainer.games.insert(game, at: 0)
					}
				case .failure(let error):
					print("Import failed: \(error.localizedDescription)")
			}
		}
	}
}


#Preview {
	GameImportButton(name: "Import File")
		.environment(DataContainer())
}
