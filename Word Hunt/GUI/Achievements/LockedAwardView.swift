//
//  LockedAwardView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 13.07.2026.
//

import SwiftUI

struct LockedAwardView: View {
	var badge: Badge
	
	var body: some View {
		HStack {
			Image(badge.details.image)
				.resizable()
				.grayscale(1.0)
				.frame(width: 70, height: 70)
				.padding(.trailing, 16)
			VStack(alignment: .leading, spacing: 8) {
				Text(badge.details.title)
					.font(.subheadline.bold())
				Text(badge.details.requirements)
					.font(.caption)
			}
			Spacer()
		}
		.padding()
		.background(Color.secondary.opacity(0.3))
		.clipShape(RoundedRectangle(cornerRadius: 16))
	}
}

#Preview {
	LockedAwardView(badge: .sample)
}
