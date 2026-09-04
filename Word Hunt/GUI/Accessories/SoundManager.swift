//
//  SoundManager.swift
//  Word Hunt
//
//  Created by Google AI on 28.08.2026.
//

import AVFoundation

struct QueuedSound {
	let url: URL
	let volume: Float
}

class SoundManager: NSObject, AVAudioPlayerDelegate {
	static let shared = SoundManager()
	
	private var audioPlayer: AVAudioPlayer?
	private var soundQueue: [QueuedSound] = []
	
	func playSound(named: String, type: String, volume: Float = 1.0) {
		guard let url = Bundle.main.url(forResource: named, withExtension: type) else { return }
		
		let track = QueuedSound(url: url, volume: volume)
		soundQueue.append(track)
		
		// If nothing is playing, kick off the queue
		if audioPlayer == nil || !audioPlayer!.isPlaying {
			playNext()
		}
	}

	private func playNext() {
		guard !soundQueue.isEmpty else {
			audioPlayer = nil
			return
		}
		
		let nextSound = soundQueue.removeFirst()
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: nextSound.url)
			audioPlayer?.delegate = self // Required to catch the completion hook
			audioPlayer?.volume = nextSound.volume
			audioPlayer?.prepareToPlay()
			audioPlayer?.play()
		} catch {
			print("Failed to play sound: \(error.localizedDescription)")
			playNext() // Skip broken file and move to next
		}
	}
	
	// MARK: - AVAudioPlayerDelegate
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		playNext() // Automatically play next track when current finishes
	}
}
