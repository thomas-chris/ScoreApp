import SwiftUI

struct OngoingGameCoordinatorView: View {
    @StateObject var mainCoordinator: OngoingGameCoordinator
    
    var body: some View {
        NavigationStack(path: $mainCoordinator.path) {
            mainCoordinator.build(.ongoingGames)
                .navigationDestination(for: Screen.self) { screen in
                    mainCoordinator.build(screen)
                }
            
        }
        .sheet(item: $mainCoordinator.sheet) { sheet in
            mainCoordinator.build(sheet)
        }
    }
}
