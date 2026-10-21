//
//  GameCenterView.swift
//  Word Sleuth
//
//  Created by Google AI on 21.10.2026.
//

import SwiftUI
import GameKit

struct GameCenterAuthView: UIViewControllerRepresentable {
	let viewController: UIViewController
	
	func makeUIViewController(context: Context) -> UIViewController {
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct GameCenterDashboardView: UIViewControllerRepresentable {
	@Binding var isPresented: Bool
	var state: GKGameCenterViewControllerState = .default
	
	func makeUIViewController(context: Context) -> GKGameCenterViewController {
		let viewController = GKGameCenterViewController(state: state)
		viewController.gameCenterDelegate = context.coordinator
		return viewController
	}
	
	func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(isPresented: $isPresented)
	}
	
	class Coordinator: NSObject, GKGameCenterControllerDelegate {
		@Binding var isPresented: Bool
		
		init(isPresented: Binding<Bool>) {
			_isPresented = isPresented
		}
		
		func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
			isPresented = false
		}
	}
}

struct GameCenterView: View {
	@StateObject private var gcManager = GameCenterManager()
	@State private var showDashboard = false
	
	var body: some View {
		VStack(spacing: 20) {
			Text("Word Sleuth")
				.font(.largeTitle)
				.bold()
			
			if gcManager.isAuthenticated {
				Text("Welcome, \(GKLocalPlayer.local.displayName)!")
					.foregroundColor(.green)
				
				Button(action: { showDashboard = true }) {
					Label("View Game Center", systemImage: "trophy.fill")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
			} else {
				Text("Connecting to Game Center...")
					.foregroundColor(.gray)
			}
		}
		.padding()
		// Trigger authentication when the game opens
		.onAppear {
			gcManager.authenticatePlayer()
		}
		// Force pop-up Apple login prompt if user is not signed into iOS Game Center
		.fullScreenCover(item: Binding(
			get: { gcManager.authViewController.map { IdentifiableController(vc: $0) } },
			set: { _ in gcManager.authViewController = nil }
		)) { item in
			GameCenterAuthView(viewController: item.vc)
				.edgesIgnoringSafeArea(.all)
		}
		// Pop up the Leaderboards / Achievements dashboard
		.sheet(isPresented: $showDashboard) {
			GameCenterDashboardView(isPresented: $showDashboard, state: .dashboard)
				.edgesIgnoringSafeArea(.all)
		}
	}
}

// Simple identity wrapper helper for the sheet modifier
struct IdentifiableController: Identifiable {
	let id = UUID()
	let vc: UIViewController
}


