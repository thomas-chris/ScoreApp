import SwiftUI

struct OngoingGameDetailScreen: View {
    
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            switch viewModel.ongoingGame.game.ruleSet.gameType {
                case .highScoreWins:
                    highScoreWinsView
                case .lowScoreWins:
                    Text("Low Score Wins View")
                case .rounds(let rounds):
                    roundsView(rounds: rounds)
            }
        }
        .onAppear {
            print(viewModel.ongoingGame.players)
            print(viewModel.ongoingGame.game)
        }
        .navigationTitle(viewModel.ongoingGame.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension OngoingGameDetailScreen {
    var highScoreWinsView: some View {
        Text("High Score Wins View")
    }
    
    @ViewBuilder
    func roundsView(rounds: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header row
            HStack {
                Text("")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(viewModel.ongoingGame.players, id: \.id) { player in
                    Text(player.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // Single data row
            HStack {
                Text("Number of rounds won")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(viewModel.ongoingGame.players, id: \.id) { player in
                    quantityStepper(player: player)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 400)
    }
    
    @ViewBuilder
    func quantityStepper(player: Player) -> some View {
        HStack {
            Button(action: {
                self.viewModel.decrementRoundsWon(for: player)
            }) {
                Image(systemName: "minus.circle")
                    .foregroundColor(.red)
            }
            //will be rounds won for player
            Text("\(viewModel.roundsWon(for: player))")
                
            Button(action: {
                self.viewModel.incrementRoundsWon(for: player)
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.red)
            }
        }
    }
}
