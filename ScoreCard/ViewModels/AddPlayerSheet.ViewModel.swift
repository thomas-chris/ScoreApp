import SwiftUI

extension AddPlayerSheet {
    @Observable
    class ViewModel {
        
        var newPlayerName = ""
       
        var playerService: any Service<Player>
        // Using a weak reference to avoid strong reference cycles
        weak var coordinator: PlayerCoordinator?
        
        init(coordinator: PlayerCoordinator, playerService: any Service<Player>) {
            self.coordinator = coordinator
            self.playerService = playerService
        }
        
        func add() {
            let player = Player(
                name: newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines),
            )
            playerService.insert(player)
            coordinator?.dismissSheet()
        }
        
        func dismissAlert() {
            coordinator?.dismissSheet()
        }
    }
}
