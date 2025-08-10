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
    
    enum GameType: Codable, Hashable {
        case highScoreWins(Int)
        case lowScoreWins(Int)
        case rounds(Int)
    }
    
    init(gameType: GameType, id: UUID = UUID()) {
        self.gameType = gameType
        self.id = id
    }
}

