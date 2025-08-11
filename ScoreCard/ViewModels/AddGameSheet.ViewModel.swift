import SwiftUI

extension AddGameSheet {
    @Observable
    class ViewModel {
        
        var newGameName = ""
        var gameType: GameType = .highScoreWins
        var value: Int = 0
        var gameService: any Service<Game>
        // Using a weak reference to avoid strong reference cycles
        weak var coordinator: MainCoordinator?
        
        init(coordinator: MainCoordinator, gameService: any Service<Game>) {
            self.coordinator = coordinator
            self.gameService = gameService
        }
        
        func add() {
            let game = Game(
                name: newGameName.trimmingCharacters(in: .whitespacesAndNewlines),
                ruleSet: RuleSet(
                    gameType: .init(
                        from: gameType,
                        value: value
                    )
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
