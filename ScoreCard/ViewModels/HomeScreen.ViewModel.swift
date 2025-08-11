import SwiftData
import SwiftUI

extension HomeScreen {
    @Observable
    class ViewModel {
        
        var games: [Game] = []
        var newGameName = ""
        weak var coordinator: MainCoordinator?
        let gameService: any Service<Game>
        
        init(coordinator: MainCoordinator, gameService: any Service<Game>) {
            self.coordinator = coordinator
            self.gameService = gameService
        }
        
        func createGame() {
            coordinator?.presentSheet(.createGame)
        }
        
        func dismissAlert() {
            
        }
        
        func delete(at offsets: IndexSet) {
            for offset in offsets {
                let game = games[offset]
                gameService.delete(game)
            }
            games.remove(atOffsets: offsets)
        }
        
        func showGame(_ game: Game) {
            coordinator?.showGame(game)
        }
        
        func refresh() {
            games = gameService.fetchData()
        }
    }
}
