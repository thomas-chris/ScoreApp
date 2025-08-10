import Observation
import SwiftUI
import SwiftData

struct ContentView: View {
    let viewModel: ViewModel?
    
    init(viewModel: ViewModel?) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            ForEach(viewModel?.games ?? []) { game in
                Text(game.name)
                    .onTapGesture {
                        viewModel?.showGame(game)
                    }
            }
            .onDelete { offsets in
                viewModel?.delete(at: offsets)
            }
        }
        .refreshable {
            viewModel?.refresh()
        }
        .navigationTitle("Games")
        .toolbar {
            Button(action: {
                viewModel?.createGame()
            }, label: {
                Image(systemName: "plus")
            })
        }
        .onAppear {
            viewModel?.refresh()
        }
    }
}
