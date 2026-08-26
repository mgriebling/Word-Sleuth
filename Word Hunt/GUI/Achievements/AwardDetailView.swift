//
//  AwardView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 13.07.2026.
//

import SwiftUI

struct AwardDetailView: View {
	var badge: Badge
	
    var body: some View {
		ScrollView {
			VStack(spacing: 8) {
				Image(badge.details.image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 170, height: 170)
				Text(badge.details.title)
					.font(.title.bold())
				Text(badge.details.congratulatoryMessage)
					.font(.body)
				Spacer()
				if let timestamp = badge.timestamp {
					Text(timestamp, style: .date)
						.font(.caption.bold())
				}
			}
			.padding()
			.frame(width: 320)
			.frame(minHeight: 410)
			.fixedSize()
			.multilineTextAlignment(.center)
			.foregroundColor(.white)
			.background(badge.details.color.opacity(0.8))
			.clipShape(RoundedRectangle(cornerRadius: 16))
		}
		.scrollBounceBehavior(.basedOnSize)
		//.defaultScrollAnchor(.center, for: .alignment)
    }
}

#Preview {
	AwardDetailView(badge: .sample)
}
