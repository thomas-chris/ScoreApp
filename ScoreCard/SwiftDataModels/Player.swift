import Foundation
import SwiftData

@Model class Player: HasName {
    
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \OngoingGame.players) var attachedGames: [OngoingGame]
    
    init(name: String, id: UUID = UUID(), attachedGames: [OngoingGame] = []) {
        self.name = name
        self.id = id
        self.attachedGames = attachedGames
    }
    
    func attach(_ game: OngoingGame) {
        if !attachedGames.contains(where: { $0.id == game.id }) {
            attachedGames.append(game)
        }
    }
    
}
