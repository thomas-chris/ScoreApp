import Foundation
import SwiftData

@Model class OngoingGame: Identifiable {
    
    @Attribute(.unique) var id: UUID
    var game: Game
    var players: [Player]
    var scores: [String: Int] = [:] // Dictionary with Player ID as key and score as value
    
    init(game: Game, players: [Player], id: UUID = UUID()) {
        self.game = game
        self.players = players
        self.id = id
    }
    
}
