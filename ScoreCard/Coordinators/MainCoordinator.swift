import SwiftData
import SwiftUI
import Combine

class MainCoordinator: AppCoordinator {
    @Published var gamesViewModel: HomeScreen.ViewModel?
    @Published var playerViewModel: PlayersScreen.ViewModel?
    @Published var path: NavigationPath
    @Published var sheet: Sheet?
    @Published var selectedTab: Int = 0
    
    let gameService: any Service<Game>
    let playerService: any Service<Player>
    let parentCoordinator: (any AppCoordinator)? = nil
    
    init(gameService: any Service<Game>, playerService: any Service<Player>) {
        self.gameService = gameService
        self.playerService = playerService
        self.path = NavigationPath()
        self.gamesViewModel = HomeScreen.ViewModel(coordinator: self, gameService: gameService)
        self.playerViewModel = PlayersScreen.ViewModel(coordinator: self, playerService: playerService)
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
        gamesViewModel?.refresh()
        playerViewModel?.refresh()
    }
    
    func showGame(_ game: Game) {
        push(.gameDetail(game))
    }
    
    func showPlayer(_ player: Player) {
        print("Show player detail not implemented yet")
    }
    
    func switchTab(_ index: Int) {
        selectedTab = index
    }

}

extension MainCoordinator {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
            case .home:
                HomeScreen(viewModel: gamesViewModel)
            case .gameDetail(let game):
                GameScreen(viewModel: GameScreen.ViewModel(game: game, coordinator: self))
            case .players:
                PlayersScreen(viewModel: playerViewModel)
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
            case Sheet.createGame:
                AddGameSheet(viewModel: .init(coordinator: self, gameService: gameService))
            case .createPlayer:
                AddPlayerSheet(viewModel: .init(coordinator: self, playerService: playerService))
        }
    }
}
