import SwiftData
import SwiftUI
import Combine

class OngoingGameCoordinator: MainCoordinator {
    @Published var ongoingGamesViewModel: OngoingGamesScreen.ViewModel?

    override init(parentCoordinator: (any AppCoordinator)? = nil) {
        super.init(parentCoordinator: parentCoordinator)
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
