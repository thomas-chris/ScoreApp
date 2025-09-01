import SwiftUI

extension GameScreen {
    
    @Observable
    class ViewModel {
        
        var game: Game
        weak var coordinator: (any AppCoordinator)?
        var players: [Player]
        var playerService: any Service<Player>
        var ongoingGameService: any Service<OngoingGame>
        var selectedPlayers: Set<Player> = []
        
        init(game: Game, coordinator: any AppCoordinator, playerService: any Service<Player>, ongoingGameService: any Service<OngoingGame>) {
            self.game = game
            self.coordinator = coordinator
            self.playerService = playerService
            self.ongoingGameService = ongoingGameService
            self.players = playerService.fetchData()
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
            
            let scores = selectedPlayers.reduce(into: [UUID: Int]()) { dict, player in
                dict[player.id] = 0
            }
            
            let ongoingGame = OngoingGame(
                name: "\(game.name): \(selectedPlayers.map { $0.name }.joined(separator: ", "))",
                game: game,
                players: Array(selectedPlayers),
                scores: scores,
                roundsPlayed: 0
            )
            
            ongoingGameService.insert(
                ongoingGame
            )
            
            game.ongoingGames.append(
                ongoingGame
            )
            
            coordinator?.pop()
        }
        
        func refreshPlayers() {
            players = playerService.fetchData()
        }            
    }
}


