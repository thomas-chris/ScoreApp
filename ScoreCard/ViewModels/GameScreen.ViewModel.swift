import SwiftUI

extension GameScreen {
    
    @Observable
    class ViewModel {
        
        var game: Game
        weak var coordinator: GameCoordinator?
        var players: [Player] {
            coordinator?.playerService.fetchData() ?? []
        }
        
        var selectedPlayers: [Player] = []
        
        init(game: Game, coordinator: GameCoordinator) {
            self.game = game
            self.coordinator = coordinator
        }
        
        func addToGame(_ player: Player) {
            if !selectedPlayers.contains(player) {
                selectedPlayers.append(player)
            } else {
                selectedPlayers.removeAll { $0 == player }
            }
        }
        
        func isInGame(_ player: Player) -> Bool {
            selectedPlayers.contains(player)
        }
        
        var canStartGame: Bool {
            selectedPlayers.count >= game.ruleSet.minNumberOfPlayers &&
            selectedPlayers.count <= game.ruleSet.maxNumberOfPlayers
        }
    }
}


