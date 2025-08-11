import SwiftData
import SwiftUI
import Combine

class MainCoordinator: AppCoordinator {
    @Published var contentViewModel: HomeScreen.ViewModel?
    @Published var path: NavigationPath
    @Published var sheet: Sheet?
    
    let gameService: any Service<Game>
    let parentCoordinator: (any AppCoordinator)? = nil
    var games = [Game]() {
        didSet {
            contentViewModel?.games = games
        }
    }
    
    init(gameService: any Service<Game>) {
        self.gameService = gameService
        self.path = NavigationPath()
        self.contentViewModel = HomeScreen.ViewModel(coordinator: self)
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
    }
    
    func showGame(_ game: Game) {
        push(.gameDetail(game))
    }
    
    func add(game: Game) {
        games.append(game)
        gameService.insert(game)
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let game = games[offset]
            gameService.delete(game)
        }
        games.remove(atOffsets: offsets)
    }
    
    func fetchData() {
        games = gameService.fetchData()
    }
}

extension MainCoordinator {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
            case .home:
                HomeScreen(viewModel: contentViewModel)
            case .gameDetail(let game):
                GameScreen(viewModel: GameScreen.ViewModel(game: game, coordinator: self))
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
            case Sheet.createGame:
                AddGameSheet(viewModel: .init(coordinator: self))
        }
    }
}
