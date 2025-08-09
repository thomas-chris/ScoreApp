import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    init() {}
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(coordinator.games) { game in
                    Text(game.name)
                    .onTapGesture {
                        coordinator.showGame(game)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Games")
            .toolbar {
                Button(action: {
                    coordinator.addGame()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        } detail: {
            if let selectedGame = coordinator.selectedGame {
                Text(selectedGame.name)
            } else {
                Text("Select an item")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        //        withAnimation {
        //            for index in offsets {
        //                viewModel.modelContext.delete(games[index])
        //            }
        //        }
        // delete in the view Model
    }
}

#Preview {
    let coordinator = Coordinator(modelContext: ModelContext(try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
    return ContentView()
        .environmentObject(coordinator)
}
