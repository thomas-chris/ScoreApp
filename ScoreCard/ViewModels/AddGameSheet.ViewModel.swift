import SwiftUI

extension AddGameSheet {
    @Observable
    class ViewModel {
        
        var newGameName = ""
        var gameType: GameType = .highScoreWins
        var value: Int = 0
        
        // Using a weak reference to avoid strong reference cycles
        weak var coordinator: (any AppCoordinator)?
        
        init(coordinator: any AppCoordinator) {
            self.coordinator = coordinator
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
            coordinator?.add(game: game)
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
