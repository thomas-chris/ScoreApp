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
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(
                mainCoordinator: MainCoordinator(
                    gameService : GameService(
                        modelContext: container.mainContext
                    ),
                    playerService: PlayerService(
                        modelContext: container.mainContext
                    )
                )
            )
        }
        
    }
    
    init() {
        do {
            let schema = Schema([
                Game.self,
                Player.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }
}
