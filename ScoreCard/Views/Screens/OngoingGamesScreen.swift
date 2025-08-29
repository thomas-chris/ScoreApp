import SwiftUI

struct OngoingGamesScreen: View {
    @State private var completedGamesSectionExpanded: Bool = true
    let viewModel: ViewModel?
    
    init(viewModel: ViewModel?) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section(header: Text("Ongoing Games")
                .font(.headline)
            ) {
                ForEach(viewModel?.ongoingGames ?? [], id: \.id) { game in
                    Text(game.name)
                }
                .onDelete { offsets in
                    viewModel?.deleteOngoing(at: offsets)
                }
            }
            Section(isExpanded: $completedGamesSectionExpanded
            ) {
                ForEach(viewModel?.completedGames ?? [], id: \.id) { game in
                    Text(game.name)
                }
                .onDelete { offsets in
                    viewModel?.deleteCompleted(at: offsets)
                }
            } header: {
                CollapsableHeaderSection(
                    title: "Finished Games",
                    sectionExpanded: $completedGamesSectionExpanded
                )
            }
                
        }
        .onAppear {
            viewModel?.refresh()
        }
        .refreshable {
            viewModel?.refresh()
        }
        .navigationTitle("Games")
    }
}
