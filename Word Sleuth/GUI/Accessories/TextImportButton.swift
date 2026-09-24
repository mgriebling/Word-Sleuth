//
//  TextImportButton.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 24.06.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI
import UniformTypeIdentifiers

struct TextImportButton: View {
	let name: String
	@Binding var text: String

	@State private var isImporting = false

	var body: some View {
		Button { isImporting = true }
		label: {
			HStack(spacing: 2) {
				Image(systemName: "square.and.arrow.down")
				Text(name)
			}
		}
		.fileImporter(
			isPresented: $isImporting,
			allowedContentTypes: [.text] // Change to [.pdf], [.image], etc. as needed
		) { result in
			switch result {
				case .success(let file):
					print("Imported file: \(file.absoluteString)")
					if let string = try? String(contentsOf: file, encoding: .utf8) {
						text = string
					}
				case .failure(let error):
					print("Import failed: \(error.localizedDescription)")
			}
		}
	}
}


#Preview {
	@Previewable @State var text: String = ""
	TextImportButton(name: "Import Word Text", text: $text)
		.buttonStyle(.bordered)
		.buttonBorderShape(.capsule)
}
