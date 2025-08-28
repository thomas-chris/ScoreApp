import SwiftData
import SwiftUI
import Combine

class PlayerCoordinator: MainCoordinator {
    @Published var playerViewModel: PlayersScreen.ViewModel?
    @Published var selectedTab: Int = 0
    
    let gameService: any Service<Game>
    let playerService: any Service<Player>
    
    init(gameService: any Service<Game>, playerService: any Service<Player>) {
        self.gameService = gameService
        self.playerService = playerService
        super.init()
        self.playerViewModel = PlayersScreen.ViewModel(coordinator: self, playerService: playerService)
    }
    
    override func dismissSheet() {
        self.sheet = nil

        playerViewModel?.refresh()
    }
    
    func showGame(_ game: Game) {
        push(.gameDetail(game))
    }
    
    func showPlayer(_ player: Player) {
        print("Show player detail not implemented yet")
    }
    
    override func switchTab(_ index: Int) {
        selectedTab = index
    }
    
}

extension PlayerCoordinator {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
            case .players:
                PlayersScreen(viewModel: playerViewModel)
            default:
                EmptyView()
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
            case .createPlayer:
                AddPlayerSheet(viewModel: .init(coordinator: self, playerService: playerService))
            default:
                EmptyView()
        }
    }
}
