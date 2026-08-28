//
//  SoundManager.swift
//  Word Hunt
//
//  Created by Google AI on 28.08.2026.
//

import AVFoundation

class SoundManager {
	static let shared = SoundManager()
	var audioPlayer: AVAudioPlayer?

	func playSound(named: String, type: String, volume: Float = 1.0) {
		do {
			let session = AVAudioSession.sharedInstance()
			try session.setCategory(.playback, options: [.mixWithOthers])
			try session.setActive(true)
			
			if let path = Bundle.main.path(forResource: named, ofType: type) {
				let url = URL(fileURLWithPath: path)
				audioPlayer = try AVAudioPlayer(contentsOf: url)
				audioPlayer?.volume = volume
				audioPlayer?.play()
			}
		} catch {
			print("Error playing sound: \(error.localizedDescription)")
		}
	}
}
