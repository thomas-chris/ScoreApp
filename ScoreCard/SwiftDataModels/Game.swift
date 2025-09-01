import Foundation
import SwiftData

protocol HasName: Identifiable, Hashable {
    var name: String { get set }
    var id: UUID { get set }
}

@Model class Game: HasName {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var ruleSet: RuleSet
    @Relationship(deleteRule: .cascade, inverse: \OngoingGame.game) var ongoingGames: [OngoingGame]
    
    init(
        name: String,
        id: UUID = UUID(),
        ruleSet: RuleSet,
        ongoingGames: [OngoingGame] = []
    ) {
        self.name = name
        self.id = id
        self.ruleSet = ruleSet
        self.ongoingGames = ongoingGames
    }
    
}

@Model class RuleSet {
    @Attribute(.unique) var id: UUID
    var gameType: GameType
    var minNumberOfPlayers: Int
    var maxNumberOfPlayers: Int
    
    enum GameType: Codable, Hashable {
        case highScoreWins(Int)
        case lowScoreWins(Int)
        case rounds(Int)
    }
    
    init(gameType: GameType, minNumberOfPlayers: Int, maxNumberOfPlayers: Int, id: UUID = UUID()) {
        self.gameType = gameType
        self.minNumberOfPlayers = minNumberOfPlayers
        self.maxNumberOfPlayers = maxNumberOfPlayers
        self.id = id
    }
}

