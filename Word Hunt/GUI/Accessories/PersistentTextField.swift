//
//  PersistentTextField.swift
//  Word Hunt
//
//  Created by Michael Griebling on 15.07.2026.
//

import SwiftUI

struct PersistentTextField: View {
	let placeholder: String
	@Binding var text: String
	
	init(_ placeholder: String, text: Binding<String>) {
		self.placeholder = placeholder
		self._text = text
	}
	
	// 1. Declare the focus state variable
	@FocusState private var isFieldFocused: Bool

	var body: some View {
		VStack {
			TextField("Type here...", text: $text)
				//.textFieldStyle(.roundedBorder)
				//.padding()
				// 2. Bind the focus state to this TextField
				.focused($isFieldFocused)
				// 3. Intercept the return key press
				.onSubmit {
					// Perform your action here (e.g., save data, append text)
					// print("User pressed return with text: \(text)")
					
					// 4. Force focus to stay on this field
					isFieldFocused = true
				}
		}
//		.onAppear {
//			// Optional: Automatically focus the field when the view appears
//			isFieldFocused = true
//		}
	}
}


#Preview {
	@Previewable @State var text: String = ""
	PersistentTextField("", text: $text)
}
