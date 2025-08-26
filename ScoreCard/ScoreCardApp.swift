//
//  ScoreCardApp.swift
//  ScoreCard
//
//  Created by Chris Thomas on 09/08/2025.
//

import SwiftUI
import SwiftData

@main
struct ScoreCardApp: App {
    let gameContainer: ModelContainer
    let playerContainer: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(
                mainCoordinator: MainCoordinator(
                    gameService : GameService(
                        modelContext: gameContainer.mainContext
                    ),
                    playerService: PlayerService(
                        modelContext: playerContainer.mainContext
                    )
                )
            )
        }
        
    }
    
    init() {
        do {
            gameContainer = try ModelContainer(for: Game.self)
            playerContainer = try ModelContainer(for: Player.self)
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }
}
