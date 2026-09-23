//
//  AboutView.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 11.07.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct AboutView: View {
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack {
			ViewThatFits(in: .vertical) {
				VStack {
					VStack {
						Image("mac256")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
					}
					.frame(height: 250, alignment: .center)
					
					VStack(alignment: .leading) {
						content()
					}
					.frame(width: 350, alignment: .center)
				}
				
				HStack(alignment: .top) {
					VStack {
						Image("mac256")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
					}
					.frame(width: 250, alignment: .center)
					
					VStack(alignment: .leading) {
						content()
					}
					.frame(width: 350, alignment: .center)
				}
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(action: { dismiss() }) {
						Image(systemName: "xmark")
					}
				}
			}
			#if os(macOS)
			 .padding(40)
			.frame(width: 300, height: 400) // Restrict size nicely for Mac popups
			#endif
		}
	}
	
	@ViewBuilder
	func content() -> some View {
		if let displayName = Bundle.main.displayName {
			Text(displayName).font(.system(size: 35))
		}
		if let version = Bundle.main.version {
			Text("Version: \(version)")
				.font(.headline)
				.fontWeight(.light)
				.foregroundColor(.gray)
				.padding(.bottom)
		}
		
		if let copyright = Bundle.main.copyright {
			Text(copyright + "\nAll rights reserved.")
				.font(.footnote)
				.foregroundColor(.gray)
				.padding(.bottom)
			Text(
			"""
			Zena Design™ is a wholly owned subsiduary of 
			Computer Inspirations™. [Source code](https://github.com/mgriebling/Word-Sleuth) is licensed 
			according to the BSL 1.1 (see [LICENSE](https://github.com/mgriebling/Word-Sleuth/blob/main/LICENSE) file).
			"""
			)
			.font(.footnote)
			.foregroundColor(.gray)
			.padding(.bottom)
		}
		Spacer()
	}
}

#Preview("English") {
	AboutView()
		.environment(\.locale, Locale(identifier: "en"))
}

#Preview("German") {
	AboutView()
		.environment(\.locale, Locale(identifier: "de"))
}
