//
//  ToolbarButton.swift
//  Word Hunt
//
//  Created by Michael Griebling on 16.07.2026.
//
import SwiftUI

// Subview helper to handle toolbar button selections cleanly
struct ToolbarButton: View {
	let icon: String
	let tag: Int
	@Binding var selection: Int?
	var text: String = ""
	
	@AppStorage(.settings) private var settings
	
	init(icon: String) {
		self.init(icon: icon, tag: -1, selection: .constant(-1))
	}
	
	init(text: String) {
		self.init(text: text, tag: -1, selection: .constant(-1))
	}
	
	init(text: String, tag: Int, selection: Binding<Int?>) {
		self.init(icon: "", tag: tag, selection: selection)
		self.text = text
	}
	
	init (icon: String, tag: Int, selection: Binding<Int?>) {
		self.icon = icon
		self.tag = tag
		self._selection = selection
	}
	
	var body: some View {
		let enlarged: Bool = selection == tag
		let highlight: Color = .accentColor.opacity(0.2)
		let color = tag == -1 ? Color.gray.opacity(0.35) : highlight
		Button(action: { selection = tag }) {
			if text.isEmpty {
				Image(systemName: icon)
					.aspectRatio(1, contentMode: .fit)
					.padding(12)
					.background(Circle().fill(enlarged ? color : .clear))
			} else {
				Text(text)
					.padding(12)
					.background(Capsule().fill(enlarged ? color : .clear))
			}
		}
		.font(enlarged ? .title.bold() : .title3.bold())
		.foregroundColor(enlarged ? .primary : .secondary)
		.frame(height: 44)
	}
}
