import SwiftUI

struct GameCoordinatorView: View {
    @StateObject var mainCoordinator: GameCoordinator
    
    var body: some View {
        NavigationStack(path: $mainCoordinator.path) {
            mainCoordinator.build(.home)
                .navigationDestination(for: Screen.self) { screen in
                    mainCoordinator.build(screen)
                }
            
        }
        .sheet(item: $mainCoordinator.sheet) { sheet in
            mainCoordinator.build(sheet)
        }
    }
}
