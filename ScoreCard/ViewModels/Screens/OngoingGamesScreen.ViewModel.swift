import SwiftUI

extension OngoingGamesScreen {
    
    @Observable
    class ViewModel {
        var games: [OngoingGame] = []
        weak var coordinator: OngoingGameCoordinator?
        let ongoingGameService: any Service<OngoingGame>
        
        var ongoingGames: [OngoingGame] {
            games.filter { !$0.isFinished }
        }
        
        var completedGames: [OngoingGame] {
            games.filter { $0.isFinished }
        }
        
        init(
            coordinator: OngoingGameCoordinator,
            ongoingGameService: any Service<OngoingGame>
        ) {
            self.coordinator = coordinator
            self.ongoingGameService = ongoingGameService
        }
        
        func refresh() {
            games = ongoingGameService.fetchData()
        }
    }
}
