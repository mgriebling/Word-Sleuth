//
//  Color+String.swift
//  CodeBreaker
//
//  Created by ChatGPT on 5/12/25.
//  Prompt: write an extension to iOS Color that converts it back and forth from a string
//  Followup Prompt: extend Color not uicolor
//

import SwiftUI

extension Color: @retroactive Decodable {}
extension Color: @retroactive Encodable {}

extension Color: @retroactive RawRepresentable {
	public init?(rawValue: String) {
		self = Color(hex: rawValue)
	}
	
	public var rawValue: String {
		self.hex
	}
}

extension Color {
    /// Initialize a SwiftUI Color from a hex string like "#RRGGBB" or "#RRGGBBAA"
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
			self = .white; return
        }

        switch hexSanitized.count {
        case 6: // RRGGBB
            let r = Double((rgb & 0xFF0000) >> 16) / 255
            let g = Double((rgb & 0x00FF00) >> 8) / 255
            let b = Double(rgb & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b)
        case 8: // RRGGBBAA
            let r = Double((rgb & 0xFF000000) >> 24) / 255
            let g = Double((rgb & 0x00FF0000) >> 16) / 255
            let b = Double((rgb & 0x0000FF00) >> 8) / 255
				let a = 255.0  // ignore opacity
            self.init(red: r, green: g, blue: b, opacity: a)
        default:
			self = .white
        }
    }

    /// Convert a SwiftUI Color to hex string like "#RRGGBB" or "#RRGGBBAA"
	var hex: String {
		#if os(macOS)
		let uiColor = NSColor(self)
		let rgbColor = uiColor.usingColorSpace(.deviceRGB) ?? UIColor.black
		#else
		let rgbColor = UIColor(self)
		#endif
		
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		let r = Int(red * 255)
		let g = Int(green * 255)
		let b = Int(blue * 255)
		// print("resolved: r: \(r), g: \(g), b: \(b)")
		return String(format: "#%02X%02X%02X", r, g, b)
	}
}
