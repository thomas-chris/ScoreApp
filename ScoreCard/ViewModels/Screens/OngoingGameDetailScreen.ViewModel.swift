import SwiftUI

extension OngoingGameDetailScreen {
    
    @Observable
    class ViewModel {

        var ongoingGame: OngoingGame
        var roundsWon: [UUID: String] = [:]
            
        
        init(ongoingGame: OngoingGame) {
            self.ongoingGame = ongoingGame
            for player in ongoingGame.players {
                roundsWon[player.id] = ongoingGame.scores[player.id]?.description ?? "0"
            }
        }
        
        func incrementRoundsWon(for player: Player) {
            let newScore = ((Int(roundsWon[player.id] ?? "0") ?? 0) + 1).description
            roundsWon[player.id] = newScore
        }
        
        func decrementRoundsWon(for player: Player) {
            let newScore = ((Int(roundsWon[player.id] ?? "0") ?? 0) - 1).description
            roundsWon[player.id] = newScore
        }
        
        func roundsWon(for player: Player) -> String {
            roundsWon[player.id] ?? "0"
        }
    }
}
