import SwiftData
import SwiftUI
import Combine

class OngoingGameCoordinator: MainCoordinator {
    @Published var ongoingGamesViewModel: OngoingGamesScreen.ViewModel?
    let ongoingGameService: any Service<OngoingGame>
    
    init(
        parentCoordinator: (any AppCoordinator)? = nil,
        ongoingGameService: any Service<OngoingGame>
    ) {
        self.ongoingGameService = ongoingGameService
        super.init(parentCoordinator: parentCoordinator)
        self.ongoingGamesViewModel = OngoingGamesScreen.ViewModel(
            coordinator: self,
            ongoingGameService: ongoingGameService
        )
    }

}

extension OngoingGameCoordinator {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
            case .ongoingGames:
                OngoingGamesScreen(viewModel: ongoingGamesViewModel)
            default:
                EmptyView()
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
            default:
                EmptyView()
        }
    }
}
