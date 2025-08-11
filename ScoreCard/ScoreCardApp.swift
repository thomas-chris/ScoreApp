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
                    )
                )
            )
        }
        
    }
    
    init() {
        do {
            container = try ModelContainer(for: Game.self)
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }
}
