import SwiftData
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        
        var games: [Game] = []
        var newGameName = ""
        weak var coordinator: MainCoordinator?
        
        init(coordinator: MainCoordinator) {
            self.coordinator = coordinator
        }
        
        func createGame() {
            coordinator?.presentSheet(.createGame)
        }
        
        func dismissAlert() {
            
        }
        
        func delete(at offsets: IndexSet) {
            coordinator?.delete(at: offsets)
            refresh()
        }
        
        func showGame(_ game: Game) {
            coordinator?.showGame(game)
        }
        
        func refresh() {
            coordinator?.fetchData()
            games = coordinator?.games ?? []
        }
    }
}
