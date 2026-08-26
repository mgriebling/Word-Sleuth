//
//  AboutView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 11.07.2026.
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
			Text(copyright)
				.font(.footnote)
				.foregroundColor(.gray)
				.padding(.bottom)
		}
		Spacer()
	}
}

#Preview {
	AboutView()
}
