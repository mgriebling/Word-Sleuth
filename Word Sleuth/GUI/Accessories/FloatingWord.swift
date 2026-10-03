//
//  FloatingWord.swift
//  Word Sleuth
//
//  Created by Michael Griebling on 04.09.2026.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
//

import SwiftUI

struct FloatingWord: View {
	
	let activeWord: String
	var isReversed: Bool = false
	
	@AppStorage(.settings) private var settings
	
    var body: some View {
		let cellSize: CGFloat = 30
		let grey = Color.gray.opacity(0.8)
		let frameWidth = activeWord.count/2 + 1
		let word = settings.allowReverseSelection && isReversed ? String(activeWord.reversed()) : activeWord
		VStack {
			Text(word)
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
    }
}

#Preview {
	FloatingWord(activeWord: "Testing Word")
}
