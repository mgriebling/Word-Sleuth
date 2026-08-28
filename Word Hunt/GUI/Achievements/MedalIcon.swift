//
//  MedalIcon.swift
//  Word Hunt
//
//  Created by Michael Griebling on 28.08.2026.
//

import SwiftUI

struct MedalIcon: View {
	let noMedal: Bool
	let scaling: CGFloat
	
	var body: some View {
		ZStack {
			// 1. The base medal icon
			Image(systemName: "medal")
				.resizable()
				.aspectRatio(1, contentMode: .fit)
				.foregroundStyle(Color.accentColor)
			
			DiagonalLine()
				.stroke(.background, style: StrokeStyle(lineWidth: noMedal ? 0 : 20 * scaling, lineCap: .round))
				.padding(2 * scaling)
			
			// 2. The visible diagonal strike line
			DiagonalLine()
				.stroke(.red, style: StrokeStyle(lineWidth: noMedal ? 0 : 10 * scaling, lineCap: .round))
				.padding(2 * scaling)
		}
		.frame(width: 100 * scaling, height: 100 * scaling)
	}
}

// 1. Create a custom diagonal line shape
struct DiagonalLine: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		// Top-left to bottom-right line
		path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
		return path
	}
}

#Preview {
	MedalIcon(noMedal: true, scaling: 0.8)
	MedalIcon(noMedal: false, scaling: 0.8)
}
