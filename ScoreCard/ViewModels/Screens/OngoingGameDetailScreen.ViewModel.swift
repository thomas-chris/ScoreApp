import SwiftUI

extension OngoingGameDetailScreen {
    
    // Can't use @Observalbe macro here, as the dictionary being changed doesn't trigger a redraw automatically, so need to call objectWillChange.send() manually
    class ViewModel: ObservableObject {
        
        @Published var animateWinner: Bool = false
        @Published var ongoingGame: OngoingGame {
            willSet {
                objectWillChange.send()
            }
        }
        @Published var hasUnsavedChanges = false
        @Published var roundsWon: [UUID: String] = [:] {
            willSet {
                objectWillChange.send()
            }
        }
        
        func highAndLowWinner(finishingScore: Int?) -> String? {
            guard let score = finishingScore else { return nil }
            let players = ongoingGame.scores.filter { $0.value == score }.map { $0.key }.compactMap { uuid in
                ongoingGame.players.first(where: { $0.id == uuid })?.name
            }
            return players.joined(separator: ", ")
        }
        
        var winnersName: String? {
            if ongoingGame.isFinished {
                switch ongoingGame.game.ruleSet.gameType {
                    case .highScoreWins:
                        return highAndLowWinner(finishingScore: ongoingGame.scores.values.max())
                    case .lowScoreWins:
                        return highAndLowWinner(finishingScore: ongoingGame.scores.values.min())
                    case .rounds(let rounds):
                        guard
                            let uuid = roundsWon.first(where: { $0.value == String(rounds) })?.key,
                            let player = ongoingGame.players.first(where: { $0.id == uuid })
                        else {
                            return nil
                        }
                        
                        return player.name
                }
            }
            
            return nil
        }
        
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
        
        ongoingGameService.delete(with: ongoingGame.id)
        ongoingGameService.insert(ongoingGame)
        ongoingGame = ongoingGameService.fetchData().first(where: { $0.id == ongoingGame.id }) ?? ongoingGame
        hasUnsavedChanges = false
    }
}


// Mark: Rounds functions
extension OngoingGameDetailScreen.ViewModel {
    func incrementRoundsWon(for player: Player) {

        let newScore = ((Int(roundsWon[player.id] ?? "0") ?? 0) + 1).description
        roundsWon[player.id] = newScore
        ongoingGame = OngoingGame(ongoingGame: ongoingGame, rounds: roundsWon)
        hasUnsavedChanges = true

    }
    
    func decrementRoundsWon(for player: Player) {
        let newScore = ((Int(roundsWon[player.id] ?? "0") ?? 0) - 1).description
        roundsWon[player.id] = newScore
        ongoingGame = OngoingGame(ongoingGame: ongoingGame, rounds: roundsWon)
        hasUnsavedChanges = true
        
    }
    
    func roundsWon(for player: Player) -> String {
        return roundsWon[player.id] ?? "0"
    }
}

// Mark: Score Funcions
extension OngoingGameDetailScreen.ViewModel {
    
    
    func addRound() {
        hasUnsavedChanges = true
        let highestKeyscoringRounds = ongoingGame.scoringRounds.keys.max() ?? -1
        var round = [UUID: String]()
        ongoingGame.players.forEach { player in
            round[player.id] = "0"
        }
        ongoingGame.scoringRounds[highestKeyscoringRounds + 1] = round
    }
    
    func updateScores() {
        ongoingGame.scores = ongoingGame.flattenAndSum(ongoingGame.scoringRounds)
        hasUnsavedChanges = false
    }
}

