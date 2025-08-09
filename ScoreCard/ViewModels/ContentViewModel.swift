import SwiftData
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        
        private unowned let coordinator: Coordinator
        
        init(coordinator: Coordinator) {
            self.coordinator = coordinator
        }
        
        func addGame() {
            coordinator.addGame()
        }
        
        func add(game: Game) {
            coordinator.add(game: game)
        }
        
        func fetchData() {
            coordinator.fetchData()
        }
    }
}
