//
//  ElapsedTimeTracker.swift
//  CodeBreaker
//
//  Created by CS193p Instructor on 5/21/25.
//

import SwiftUI

extension View {
    func trackElapsedTime(in game: Game) -> some View {
        self.modifier(ElapsedTimeTracker(game: game))
    }
}

struct ElapsedTimeTracker: ViewModifier {

    @Environment(\.scenePhase) var scenePhase
	
    let game: Game
    
    func body(content: Content) -> some View {
        content
            .onAppear {
				if game.isOver {
					print("Paused timer \(game.name)")
					game.timer.pause()
				} else {
					print("Started timer \(game.name)")
					game.timer.start()
				}
            }
            .onDisappear {
				print("Paused timer \(game.name)")
				game.timer.pause()
            }
            .onChange(of: game) { oldGame, newGame in
				print("Paused timer \(oldGame.name)")
				oldGame.timer.pause()
				if !newGame.isOver {
					print("Started timer \(newGame.name)")
					newGame.timer.start()
				}
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
					case .active:
						if !game.isOver {
							print("Started timer \(game.name)")
							game.timer.start()
						}
					case .background:
						print("Paused timer \(game.name)")
						game.timer.pause()
					default: break
                }
            }
    }
}

