//
//  FloatingWord.swift
//  Word Hunt
//
//  Created by Michael Griebling on 04.09.2026.
//

import SwiftUI

struct FloatingWord: View {
	
	@Binding var activeWord: String
	
	@AppStorage(.settings) private var settings
	
    var body: some View {
		let cellSize: CGFloat = 30
		//let start = dragStartCell ?? CellIndex()
		//let offset = cellSize * CGFloat(numRows) / 4
		let grey = Color(.systemGray4)
		let frameWidth = activeWord.count/2 + 1
		VStack {
			Text(activeWord)
			if settings.allowReverseSelection {
				Text(String(activeWord.reversed()))
			}
		}
		.font(.system(size: cellSize, weight: settings.fontStyle.weight))
		.lineLimit(1)
		.minimumScaleFactor(0.75)
		.allowsTightening(true)
		.fixedSize(horizontal: true, vertical: false)
		.frame(width: cellSize * CGFloat(frameWidth), height: cellSize)
		.padding(10)
		.background(grey)
		.cornerRadius(15)
		.zIndex(10)
		.opacity(activeWord.isEmpty ? 0.0 : 1.0)
		.animation(.none, value: frameWidth)
		//.offset(y: start.row > numRows/2 ? -offset : offset)
    }
}

#Preview {
	FloatingWord(activeWord: .constant("Testing Word"))
}
