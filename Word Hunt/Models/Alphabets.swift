//
//  Alphabets.swift
//  Word Hunt
//
//  Created by Google AI on 21.06.2026.
//

import Foundation

struct Alphabets {
	
	static func getAlphabet(for languageCode: String) -> String {
		// Create the locale for the target language (e.g., "es" for Spanish, "el" for Greek)
		let locale = Locale(identifier: languageCode)
		
		// Retrieve the core alphabet character set for that locale
		if let characterSet = locale.exemplarCharacterSet {
			let upper = characterSet.uppercaseStringRepresentation
			if upper.count > 0 {
				return upper
			} else {
				return characterSet.stringRepresentation
			}
		}
		return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" // default
	}
	
	static var englishAlphabet: String { getAlphabet(for: "en") }
	static var spanishAlphabet: String { getAlphabet(for: "es") }
	static var greekAlphabet: String { getAlphabet(for: "el") }
	static var italianAlphabet: String { getAlphabet(for: "it") }
	static var germanAlphabet: String { getAlphabet(for: "de") }
	static var russianAlphabet: String { getAlphabet(for: "ru") }
	static var hollandeseAlphabet: String { getAlphabet(for: "nl") }
	static var chineseAlphabet: String { getAlphabet(for: "zh-Hans") }
	static var japaneseAlphabet: String { getAlphabet(for: "ja-JP") }
	static var frenchAlphabet: String { getAlphabet(for: "fr") }
	static var arabicAlphabet: String { getAlphabet(for: "ar") }
	static var indianAlphabet: String { getAlphabet(for: "hi") }
}

extension CharacterSet {
	var stringRepresentation: String {
		let nsSet = self as NSCharacterSet
		var scalars: [UnicodeScalar] = []
		
		// Safely loop through all 17 possible Unicode planes (0 to 16)
		for plane in UInt8(0)...16 {
			// Only read the plane if Apple's framework explicitly says it contains members
			guard nsSet.hasMemberInPlane(plane) else { continue }
			
			// Calculate exact start and end code points for this specific plane
			let startCodePoint = UInt32(plane) << 16
			let endCodePoint = (UInt32(plane) + 1) << 16
			
			for codePoint in startCodePoint..<endCodePoint {
				if nsSet.longCharacterIsMember(codePoint) {
					if let scalar = UnicodeScalar(codePoint) {
						scalars.append(scalar)
					}
				}
			}
		}
		
		return String(String.UnicodeScalarView(scalars))
	}
	
	// Combined solution to filter only uppercase letters safely
	var uppercaseStringRepresentation: String {
		String(self.stringRepresentation.filter { $0.isUppercase })
	}
}


