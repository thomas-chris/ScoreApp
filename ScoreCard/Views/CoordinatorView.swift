import SwiftUI

struct CoordinatorView: View {
    @StateObject var mainCoordinator: MainCoordinator
    
    var body: some View {
        TabView {
            NavigationStack(path: $mainCoordinator.path) {
                mainCoordinator.build(.home)
                    .navigationDestination(for: Screen.self) { screen in
                        mainCoordinator.build(screen)
                    }
                    
            }
            .tabItem {
                Label("Games", systemImage: "list.dash")
            }
            NavigationStack(path: $mainCoordinator.path) {
                mainCoordinator.build(.players)
            }
            .tabItem {
                Label("Players", systemImage: "person.3")
            }
        }
        .sheet(item: $mainCoordinator.sheet) { sheet in
            mainCoordinator.build(sheet)
        }
    }
}
