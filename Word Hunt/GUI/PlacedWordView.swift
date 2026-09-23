//
//  PlacedWordView.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 01.09.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//
import SwiftUI

struct PlacedWordView: View {
	let word: PlacedWord
	
	var body: some View {
		let highlighted = word.highlighted
		let textColor = highlighted ? Color(.systemGray) : .primary
		Text(word.word.capitalized)
			.foregroundColor(textColor)
			.strikethrough(highlighted)
			.allowsTightening(true)
			.lineLimit(1)
			.fixedSize(horizontal: true, vertical: false)
	}
}
