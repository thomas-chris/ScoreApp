import SwiftUI

extension GameScreen {
    
    @Observable
    class ViewModel {
        
        var game: Game
        weak var coordinator: MainCoordinator?
        var players: [Player] = []
        
        init(game: Game, coordinator: MainCoordinator) {
            self.game = game
            self.coordinator = coordinator
        }
    }
}


