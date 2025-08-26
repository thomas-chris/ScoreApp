import Foundation
import SwiftData

@Model class Player: Identifiable {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var attachedGames: [OngoingGame] = []
    
    init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }
    
    func attach(_ game: OngoingGame) {
        if !attachedGames.contains(where: { $0.id == game.id }) {
            attachedGames.append(game)
        }
    }
    
}
