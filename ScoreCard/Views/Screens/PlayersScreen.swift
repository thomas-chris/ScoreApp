import SwiftUI

struct PlayersScreen: View {
    let viewModel: ViewModel?
    
    init(viewModel: ViewModel?) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            ForEach(viewModel?.players ?? [], id: \.id) { player in
                Text(player.name)
                    .onTapGesture {
//                        viewModel?.showGame(player)
                    }
            }
            .onDelete { offsets in
                viewModel?.delete(at: offsets)
            }
        }
        .refreshable {
            viewModel?.refresh()
        }
        .navigationTitle("Players")
        .toolbar {
            Button(action: {
                viewModel?.createPlayer()
            }, label: {
                Image(systemName: "plus")
            })
        }
        .onAppear {
            viewModel?.refresh()
        }
    }
    
}
