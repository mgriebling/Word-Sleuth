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
    // @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
	
    let game: Game
    
    func body(content: Content) -> some View {
        content
            .onAppear {
				if game.isOver {
					game.timer.pause()
				} else {
					game.timer.start()
				}
            }
            .onDisappear {
				game.timer.pause()
            }
            .onChange(of: game) { oldGame, newGame in
				oldGame.timer.pause()
				if !newGame.isOver {
					newGame.timer.start()
				}
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
					case .active: if !game.isOver { game.timer.start() }
					case .background: game.timer.pause()
					default: break
                }
            }
//            .onReceive(modelContextWillSavePublisher) { _ in
//				game.timer.update()
//				print("updated elapsed time to \(game.timer.elapsedTime)")
//            }
    }
}

