import SwiftUI

struct PlayerCoordinatorView: View {
    @StateObject var mainCoordinator: PlayerCoordinator
    
    var body: some View {
        NavigationStack(path: $mainCoordinator.path) {
            mainCoordinator.build(.players)
                .navigationDestination(for: Screen.self) { screen in
                    mainCoordinator.build(screen)
                }
            
        }
        .sheet(item: $mainCoordinator.sheet) { sheet in
            mainCoordinator.build(sheet)
        }
    }
}
