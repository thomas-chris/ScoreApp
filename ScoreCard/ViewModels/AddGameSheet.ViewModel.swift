import SwiftUI

extension AddGameSheet {
    @Observable
    class ViewModel {
        
        var newGameName = ""
        weak var coordinator: (any AppCoordinator)?
        
        init(coordinator: any AppCoordinator) {
            self.coordinator = coordinator
        }
        
        func add() {
            let game = Game(name: newGameName.trimmingCharacters(in: .whitespacesAndNewlines))
            coordinator?.add(game: game)
            coordinator?.fetchData()
            newGameName = ""
        }
        
        func dismissAlert() {
            coordinator?.dismissSheet()
        }
    }
}

    
