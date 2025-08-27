import SwiftUI

struct GameDefinitionCoordinatorView: View {
    @StateObject var mainCoordinator: GameDefinitionsCoordinator
    
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
