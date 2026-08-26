//
//  TextFieldClearButton.swift
//  Word Hunt
//
//  From swiftprogramming.com on 15.07.2026.
//

import SwiftUI

// 1. Create the custom ViewModifier
struct TextFieldClearButton: ViewModifier {
	@Binding var text: String

	func body(content: Content) -> some View {
		HStack {
			content
			if !text.isEmpty {
				Button(action: { self.text = "" }) {
					Image(systemName: "multiply.circle.fill")
						.foregroundColor(.gray)
				}
				.buttonStyle(.plain)
			}
		}
	}
}

// 2. Create an extension for cleaner syntax
extension View {
	func showClearButton(_ text: Binding<String>) -> some View {
		self.modifier(TextFieldClearButton(text: text))
	}
}

// 3. Usage in your Views
private struct TextFieldClearButtonView: View {
	@State private var username = ""

	var body: some View {
		TextField("Username", text: $username)
			.showClearButton($username)
			.padding()
			.textFieldStyle(.roundedBorder)
	}
}


#Preview {
    TextFieldClearButtonView()
}
