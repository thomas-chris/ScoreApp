import SwiftData
import SwiftUI
import Combine

class OngoingGameCoordinator: AppCoordinator {
    var path: NavigationPath
    var sheet: Sheet?
    var parentCoordinator: (any AppCoordinator)?

    init(parentCoordinator: (any AppCoordinator)? = nil) {
        self.path = NavigationPath()
        self.parentCoordinator = parentCoordinator
    }
    
    func push(_ screen: Screen) {
        
    }

    func presentSheet(_ sheet: Sheet) {
        
    }

    func pop() {
        
    }

    func popToRoot() {
        
    }

    func dismissSheet() {
        
    }

    func switchTab(_ index: Int) {
        
    }

}

extension OngoingGameCoordinator {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
            case .ongoingGames:
                Text("Ongoing Games")
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
