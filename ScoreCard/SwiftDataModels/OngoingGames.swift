import Foundation
import SwiftData

@Model class OngoingGame: HasName {
    
    @Attribute(.unique) var id: UUID
    var game: Game
    var players: [Player]
    var scores: [UUID: Int] // Dictionary with Player ID as key and score as value
    var roundsPlayed: Int

    var name: String
    
    var isFinished: Bool {
        switch game.ruleSet.gameType {
            case .rounds(let totalRounds):
                return roundsPlayed >= totalRounds
            case .highScoreWins(let targetScore), .lowScoreWins(let targetScore):
                return scores.values.contains(where: { $0 >= targetScore })
        }
    }
    
    
    init(
        name: String,
        game: Game,
        players: [Player],
        scores: [UUID: Int],
        roundsPlayed: Int,
        id: UUID = UUID()
    ) {
        self.name = name
        self.game = game
        self.players = players
        self.roundsPlayed = roundsPlayed
        self.scores = scores
        self.id = id
    }
    
}
