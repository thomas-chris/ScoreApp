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

extension OngoingGame {
    convenience init(ongoingGame: OngoingGame, rounds: [UUID: String]) {
        self.init(
            name: ongoingGame.name,
            game: ongoingGame.game,
            players: ongoingGame.players,
            scores: (rounds.reduce(into: ongoingGame.scores) { partialResult, entry in
                let (playerID, scoreString) = entry
                if let score = Int(scoreString) {
                    partialResult[playerID] = (partialResult[playerID] ?? 0) + score
                }
            }),
            roundsPlayed: (rounds.values.map { Int($0) ?? 0 }.reduce(0, +)),
            id: ongoingGame.id
        )
        
    }
}
        
