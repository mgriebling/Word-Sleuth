//
//  PlacedWordView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 01.09.2026.
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
