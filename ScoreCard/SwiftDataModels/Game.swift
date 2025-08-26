import Foundation
import SwiftData

@Model class Game: Identifiable {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var ruleSet: RuleSet
    
    init(name: String, id: UUID = UUID(), ruleSet: RuleSet) {
        self.name = name
        self.id = id
        self.ruleSet = ruleSet
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

