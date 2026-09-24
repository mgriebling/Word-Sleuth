//
//  ElapsedTimeTracker.swift
//  Word Sleuth
//
//  Created by CS193p Instructor on 5/21/25.
//  Copyright © 2026 Computer Inspirations. All rights reserved.
//  Source code licensed according to the BSL 1.1 (see LICENSE file).
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
			.task {
				// start timer if onAppear didn't activate
				try? await Task.sleep(for: .seconds(2))
				if game.timer.state != .running {
//					print("Task \(game.name) started")
					game.timer.handleViewAppearing()
				}
			}
            .onAppear {
				game.timer.handleViewAppearing()
            }
            .onDisappear {
				game.timer.handleViewDisappearing()
            }
			.onChange(of: game) { oldValue, newValue in
				newValue.timer.handleViewAppearing()
				oldValue.timer.handleViewDisappearing()
			}
            .onChange(of: scenePhase) {
				switch scenePhase {
					case .active:
						game.timer.handleViewAppearing()
					case .background:
						game.timer.handleViewDisappearing()
					default:
						break
				}
            }
    }
}

