import SwiftUI

extension AddGameSheet {
    @Observable
    class ViewModel {
        
        var newGameName = ""
        var minNumberOfPlayers = "2"
        var maxNumberOfPlayers = "8"
        var gameType: GameType = .highScoreWins
        var value: Int = 0
        var gameService: any Service<Game>
        // Using a weak reference to avoid strong reference cycles
        weak var coordinator: GameCoordinator?
        
        init(coordinator: GameCoordinator, gameService: any Service<Game>) {
            self.coordinator = coordinator
            self.gameService = gameService
        }
        
        func add() {
            let minNumberOfPlayers = Int(minNumberOfPlayers) ?? 2
            let maxNumberOfPlayers = Int(maxNumberOfPlayers) ?? 8
            let game = Game(
                name: newGameName.trimmingCharacters(in: .whitespacesAndNewlines),
                ruleSet: RuleSet(
                    gameType: .init(
                        from: gameType,
                        value: value
                    ),
                    minNumberOfPlayers: minNumberOfPlayers,
                    maxNumberOfPlayers: maxNumberOfPlayers
                )
            )
            gameService.insert(game)
            coordinator?.dismissSheet()
        }
        
        func dismissAlert() {
            coordinator?.dismissSheet()
        }
    }
}

extension AddGameSheet.ViewModel {
    enum GameType {
        case highScoreWins
        case lowScoreWins
        case rounds
    }
}

extension RuleSet.GameType {
    init(from gameType: AddGameSheet.ViewModel.GameType, value: Int) {
        switch gameType {
            case .highScoreWins:
                self = .highScoreWins(value)
            case .lowScoreWins:
                self = .lowScoreWins(value)
            case .rounds:
                self = .rounds(value)
        }
    }
}
