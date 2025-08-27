import SwiftUI

extension GameScreen {
    
    @Observable
    class ViewModel {
        
        var game: Game
        weak var coordinator: GameDefinitionsCoordinator?
        var players: [Player]
        
        var selectedPlayers: Set<Player> = []
        
        init(game: Game, coordinator: GameDefinitionsCoordinator) {
            self.game = game
            self.coordinator = coordinator
            self.players = coordinator.playerService.fetchData()
        }
        
        func toggle(_ player: Player) {
            if !selectedPlayers.contains(player) {
                selectedPlayers.insert(player)
            } else {
                selectedPlayers.remove(player)
            }
        }
        
        func isInGame(_ player: Player) -> Bool {
            selectedPlayers.contains(player)
        }
        
        var canStartGame: Bool {
            selectedPlayers.count >= game.ruleSet.minNumberOfPlayers &&
            selectedPlayers.count <= game.ruleSet.maxNumberOfPlayers
        }
        
        func startGame() {
            // Logic to start the game with selected players
            print("Starting game \(game.name) with players: \(selectedPlayers.map { $0.name }.joined(separator: ", "))")
        }
        
        func refreshPlayers() {
            players = coordinator?.playerService.fetchData() ?? []
        }
    }
}


