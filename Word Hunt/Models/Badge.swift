//
//  Badge.swift
//  Word Hunt
//
//  Created by Michael Griebling on 13.07.2026.
//

import Foundation

/// Use `timestamp` to determine if a badge is unlocked.
/// A `Game` may be deleted but the timestamp stays.
/// Once awarded, badges aren't relocked.
///
final class Badge {
	var details: BadgeDetails
	var game: Game?
	var timestamp: Date?
	
	init(details: BadgeDetails, game: Game? = nil, timestamp: Date? = nil) {
		self.details = details
		self.game = game
		self.timestamp = timestamp
	}
	
	/// Copies a badge
	init(badge: Badge) {
		self.details = badge.details
		self.game = badge.game
		self.timestamp = badge.timestamp
	}
	
	// MARK: Required for manual Codable compliance, warning issued otherwise
	required init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.details = try container.decode(BadgeDetails.self, forKey: .details)
		self.timestamp = try container.decode(Date.self, forKey: .timestamp)
	}
	
	convenience init?(from file: URL) {
		if let rawData = try? Data(contentsOf: file) {
			let decoder = JSONDecoder()
			if let badge = try? decoder.decode(Badge.self, from: rawData) {
				print("Loaded badge: \(badge.details.title)")
				self.init(badge: badge)
				return
			} else {
				// remove corrupted file
				try? FileManager.default.removeItem(at: file)
			}
		}
		return nil
	}
	
	func save(to fileName: String) {
		let encoder = JSONEncoder()
		// encoder.dataEncodingStrategy = .deferredToData
		// encoder.outputFormatting = .prettyPrinted // Makes the JSON file human-readable
		
		do {
			// 5. Encode the class instance into raw Data
			let jsonData = try encoder.encode(self)
			
			// 6. Write the raw Data to disk
			try jsonData.write(to: url(name: fileName), options: .atomic)
		} catch {
			print("Failed to write JSON file: \(error.localizedDescription)")
		}
	}
	
	func url(name: String) -> URL {
		Self.documentDirectory!.appendingPathComponent("\(name).\(Self.fileExt)")
	}
	
	static func save(badges: [Badge]) { badges.forEach { $0.save(to: $0.details.title) } }
	
	static func loadBadges() -> [Badge] {
		guard let documentsURL = Self.documentDirectory else { return [] }
		let fileManager = FileManager.default
		do {
			let contents = try fileManager.contentsOfDirectory(at: documentsURL,
					includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
			
			// Filter for files with extension (case-insensitive)
			let badgeURLs = contents.filter { $0.pathExtension.lowercased() == Self.fileExt }
			var badges = [Badge]()
			for url in badgeURLs {
				if let badge = Badge(from: url) {
					badges.append(badge)
				}
			}
			return badges
		} catch {
			print("Error reading directory: \(error)")
			return []
		}
	}
	
	static var documentDirectory: URL? {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
	}
	
	static var fileExt: String { "badge" }
}

extension Badge: Identifiable { }

extension Badge {
	static var sample: Badge {
		Badge(details: .puzzle1, timestamp: .now)
	}
}

extension Badge: Codable {
	
	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(details, forKey: .details)
		try container.encode(timestamp, forKey: .timestamp)
	}
	
	enum CodingKeys: String, CodingKey { case details, timestamp }
}
