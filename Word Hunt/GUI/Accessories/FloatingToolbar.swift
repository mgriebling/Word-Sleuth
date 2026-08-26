//
//  FloatingToolbar2.swift
//  Word Hunt
//
//  Enhanced by Michael Griebling on 15.07.2026.
//  Original from Google AI.
//

import SwiftUI

// 2. The Floating Toolbar View
struct FloatingToolbar: View {
	@Binding var selectedTab: Int?
	var toolbarButtons: [ToolbarButton] = []
	
	@State private var items: [ToolbarButton] = []
	
	var body: some View {
		HStack(spacing: 20) {
			ForEach(items.indices, id: \.self) { index in
				items[index]
			}
		}
		.onAppear {
			if toolbarButtons.isEmpty {
				items = [
					ToolbarButton(icon: "house.fill", tag: 0, selection: $selectedTab),
					ToolbarButton(icon: "magnifyingglass", tag: 1, selection: $selectedTab),
					ToolbarButton(icon: "plus"),
					ToolbarButton(text: "Settings"), // , tag: 4, selection: $selectedTab),
					ToolbarButton(icon: "bell.fill", tag: 2, selection: $selectedTab),
					ToolbarButton(icon: "gearshape.fill", tag: 3, selection: $selectedTab)
				]
			} else {
				items = toolbarButtons
			}
		}
		.padding(.horizontal)
		.padding(.vertical)
		.background(.primary.opacity(0.15), in: Capsule())
		.shadow(color: .secondary.opacity(0.3), radius: 10, x: 0, y: 5)
	}
}

#Preview {
	@Previewable @State var selectedTab: Int? = 0
	FloatingToolbar(selectedTab: $selectedTab)
}
