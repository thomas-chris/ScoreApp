import SwiftData
import SwiftUI
import Combine

class GameDefinitionsCoordinator: MainCoordinator {
    @Published var gamesViewModel: GameDefinitionScreen.ViewModel?
    @Published var selectedTab: Int = 0
    
    let gameService: any Service<Game>
    let playerService: any Service<Player>
    
    init(gameService: any Service<Game>, playerService: any Service<Player>) {
        self.gameService = gameService
        self.playerService = playerService
        super.init()
        self.gamesViewModel = GameDefinitionScreen.ViewModel(coordinator: self, gameService: gameService)
    }
    
    override func dismissSheet() {
        self.sheet = nil
        gamesViewModel?.refresh()
    }
    
    func showGame(_ game: Game) {
        push(.gameDetail(game))
    }
    
    override func switchTab(_ index: Int) {
        selectedTab = index
    }

}

extension GameDefinitionsCoordinator {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
            case .home:
                GameDefinitionScreen(viewModel: gamesViewModel)
            case .gameDetail(let game):
                GameScreen(viewModel: GameScreen.ViewModel(game: game, coordinator: self, playerService: playerService))
            default:
                EmptyView()
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
            case Sheet.createGame:
                AddGameSheet(viewModel: .init(coordinator: self, gameService: gameService))
            default:
                EmptyView()
        }
    }
}
