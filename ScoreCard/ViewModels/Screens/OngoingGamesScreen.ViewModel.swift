import SwiftUI

extension OngoingGamesScreen {
    
    @Observable
    class ViewModel {
        var games: [OngoingGame] = []
        weak var coordinator: (any AppCoordinator)?
        let ongoingGameService: any Service<OngoingGame>
        
        var ongoingGames: [OngoingGame] {
            games.filter { !$0.isFinished }
        }
        
        var completedGames: [OngoingGame] {
            games.filter { $0.isFinished }
        }
        
        init(
            coordinator: any AppCoordinator,
            ongoingGameService: any Service<OngoingGame>
        ) {
            self.coordinator = coordinator
            self.ongoingGameService = ongoingGameService
        }
        
        func refresh() {
            games = ongoingGameService.fetchData()
        }
        
        func deleteOngoing(at offsets: IndexSet) {
            for offset in offsets {
                let game = ongoingGames[offset]
                ongoingGameService.delete(game)
            }
            
            games = ongoingGameService.fetchData()
        }
        
        func deleteCompleted(at offsets: IndexSet) {
            for offset in offsets {
                let game = completedGames[offset]
                ongoingGameService.delete(game)
            }
            
            games = ongoingGameService.fetchData()
        }
    }
}
