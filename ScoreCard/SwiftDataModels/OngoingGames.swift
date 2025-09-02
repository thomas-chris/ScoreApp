import Foundation
import SwiftData

@Model class OngoingGame: HasName {
    
    @Attribute(.unique) var id: UUID
    var game: Game
    var players: [Player]
    var scores: [UUID: Int] {
        willSet {
            objectWillChange.send()
        }
    } // Dictionary with Player ID as key and score as value
    var roundsPlayed: Int
    var scoringRounds: [Int: [UUID: String]] {
        willSet {
            objectWillChange.send()
            roundsPlayed = scoringRounds.count
            scores = flattenAndSum(scoringRounds)
        }
    }
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
        scoringRounds: [Int: [UUID: String]],
        id: UUID = UUID()
    ) {
        self.name = name
        self.game = game
        self.players = players
        self.roundsPlayed = roundsPlayed
        self.scores = scores
        self.scoringRounds = scoringRounds
        self.id = id
    }
    
    func flattenAndSum(_ input: [Int: [UUID: String]]) -> [UUID: Int] {
        var result: [UUID: Int] = [:]
        for round in input.values {
            for (playerId, score) in round {
                result[playerId, default: 0] += Int(score) ?? 0
            }
        }
        return result
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
            scoringRounds: ongoingGame.scoringRounds,
            id: ongoingGame.id
        )
        
    }
}
        
