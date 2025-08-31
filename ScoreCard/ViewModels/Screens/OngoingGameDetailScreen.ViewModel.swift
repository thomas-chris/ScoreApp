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
        
        let ongoingGameService: any Service<OngoingGame>
        
        init(ongoingGame: OngoingGame, ongoingGameService: any Service<OngoingGame>) {
            self.ongoingGame = ongoingGame
            self.ongoingGameService = ongoingGameService
            for player in ongoingGame.players {
                roundsWon[player.id] = ongoingGame.scores[player.id]?.description ?? "0"
            }
        }
    }
}

// MARK: All Game Functions

extension OngoingGameDetailScreen.ViewModel {
        
    func saveGame() {
        
        // doing a delete then an insert, as I am not using the model context directly.
        // Seems like SwiftData and ViewModels don't interact well for updates - SwiftData models want to be the ViewModel. But that doesn't play nice with the other stuff you want in a view model
        // doing them with a gap also seems to make the app behave better - not sure why
        let newOngoingGame = OngoingGame(ongoingGame: ongoingGame, rounds: roundsWon)
        ongoingGameService.delete(ongoingGame)
        ongoingGame = newOngoingGame
        ongoingGameService.insert(newOngoingGame)
        hasUnsavedChanges = false
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
