import SwiftUI

extension OngoingGameDetailScreen {
    
    // Can't use @Observalbe macro here, as the dictionary being changed doesn't trigger a redraw automatically, so need to call objectWillChange.send() manually
    class ViewModel: ObservableObject {
        
        @Published var ongoingGame: OngoingGame
        @Published var roundsWon: [UUID: String] = [:] {
            willSet {
                objectWillChange.send()
            }
        }
        @Published var hasUnsavedChanges = false
        @Published var gameOver = false
        
        init(ongoingGame: OngoingGame) {
            self.ongoingGame = ongoingGame
            for player in ongoingGame.players {
                roundsWon[player.id] = ongoingGame.scores[player.id]?.description ?? "0"
            }
        }
        
    }
}

// Mark: Rounds functions
extension OngoingGameDetailScreen.ViewModel {
    func incrementRoundsWon(for player: Player) {
        hasUnsavedChanges = true
        let newScore = ((Int(roundsWon[player.id] ?? "0") ?? 0) + 1).description
        roundsWon[player.id] = newScore
    }
    
    func decrementRoundsWon(for player: Player) {
        hasUnsavedChanges = true
        let newScore = ((Int(roundsWon[player.id] ?? "0") ?? 0) - 1).description
        roundsWon[player.id] = newScore
    }
    
    func roundsWon(for player: Player) -> String {
        return roundsWon[player.id] ?? "0"
    }
}
