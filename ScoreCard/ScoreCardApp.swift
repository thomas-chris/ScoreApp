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
            TabView {
                GameDefinitionCoordinatorView(
                    mainCoordinator: GameDefinitionsCoordinator(
                        gameService : GameService(
                            modelContext: container.mainContext
                        ),
                        playerService: PlayerService(
                            modelContext: container.mainContext
                        )
                    )
                )
                .tabItem {
                    Label("Games", systemImage: "list.dash")
                }
                PlayerCoordinatorView(
                    mainCoordinator: PlayerCoordinator(
                        gameService: GameService(
                            modelContext: container.mainContext
                        ),
                        playerService: PlayerService(
                            modelContext: container.mainContext
                        )
                    )
                )
                .tabItem {
                    Label("Players", systemImage: "person.3")
                }
                OngoingGameCoordinatorView(mainCoordinator: OngoingGameCoordinator()
                )
                .tabItem {
                    Label("Ongoing Games", systemImage: "arcade.stick.console")
                }
            }
        }
        
    }
    
    init() {
        do {
            let schema = Schema([
                Game.self,
                Player.self,
                OngoingGame.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer for Game.")
        }
    }
}
