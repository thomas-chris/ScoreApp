import SwiftUI

struct CoordinatorView: View {
    @StateObject var mainCoordinator: MainCoordinator
    
    var body: some View {
        TabView {
            Group {
                NavigationStack(path: $mainCoordinator.path) {
                    mainCoordinator.build(.home)
                        .navigationDestination(for: Screen.self) { screen in
                            mainCoordinator.build(screen)
                        }
                    
                }
                .tabItem {
                    Label("Games", systemImage: "list.dash")
                }
                .tag(0)
                NavigationStack(path: $mainCoordinator.path) {
                    mainCoordinator.build(.players)
                }
                .tabItem {
                    Label("Players", systemImage: "person.3")
                }
                .tag(1)
            }
            
        }
        .sheet(item: $mainCoordinator.sheet) { sheet in
            mainCoordinator.build(sheet)
        }
    }
}
