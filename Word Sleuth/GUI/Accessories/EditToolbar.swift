//
//  EditToolbar.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 01.07.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct EditToolbar: ToolbarContent {
	var okDisabled: Bool = false
	let onDone: (() -> Void)?
	
	// MARK: Data (Function) In
	@Environment(\.dismiss) var dismiss
	
	var body: some ToolbarContent {
		ToolbarItem(placement: .cancellationAction) {
			Button(action: { dismiss() }) {
				Image(systemName: "xmark")
			}
			.tint(Color(.systemRed))
		}
		ToolbarItem(placement: .confirmationAction) {
			Button(action: { onDone?(); dismiss() }) {
				Image(systemName: "checkmark")
			}
			.tint(Color(.systemGreen))
			.disabled(okDisabled)
		}
	}
}
