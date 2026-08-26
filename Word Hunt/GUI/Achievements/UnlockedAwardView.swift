//
//  AwardView.swift
//  Word Hunt
//
//  Created by Michael Griebling on 13.07.2026.
//

import SwiftUI

struct UnlockedAwardView: View {
	var badge: Badge
	
	var body: some View {
		NavigationLink {
			AwardDetailView(badge: badge)
		} label: {
			VStack(alignment: .leading, spacing: 8) {
				Image(badge.details.image)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 70, height: 70)
					.frame(maxWidth: .infinity, alignment: .center)
				Text(badge.details.title)
					.font(.headline.bold())
				Text(badge.details.congratulatoryMessage)
					.font(.caption2)
				Spacer()
				if let timestamp = badge.timestamp {
					Text(timestamp, style: .date)
						.font(.caption.bold())
				}
			}
			.padding()
			.frame(width: 210)
			.frame(minHeight: 225)
			.fixedSize()
			.multilineTextAlignment(.leading)
			.foregroundColor(.white)
			.background(badge.details.color.opacity(0.8))
			.clipShape(RoundedRectangle(cornerRadius: 16))
		}
    }
}

#Preview {
	AwardDetailView(badge: .sample)
}
