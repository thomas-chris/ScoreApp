import SwiftUI

struct OngoingGameDetailScreen: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var saveImage: Image {
        if viewModel.hasUnsavedChanges {
            return Image(systemName: "opticaldisc")
        } else {
            return Image(systemName: "opticaldisc.fill")
        }
    }
    
    var body: some View {
        ScrollView {
            if viewModel.hasUnsavedChanges {
                Text("Warning - unsaved changes")
                    .foregroundColor(.red)
            }
            switch viewModel.ongoingGame.game.ruleSet.gameType {
                case .highScoreWins:
                    highScoreWinsView
                case .lowScoreWins:
                    Text("Low Score Wins View")
                case .rounds(let rounds):
                    roundsView(rounds: rounds)
            }
            
        }
        .toolbar {
            Button(action: {
                viewModel.saveGame()
            }, label: {
                saveImage
            })
        }
        .navigationTitle(viewModel.ongoingGame.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension OngoingGameDetailScreen {
    var highScoreWinsView: some View {
        Text("High Score Wins View")
    }
    
    
}

// MARK: - Rounds View

extension OngoingGameDetailScreen {
    
    @ViewBuilder
    func roundsView(rounds: Int) -> some View {
        table(rounds: rounds)
            
        
        if viewModel.ongoingGame.isFinished {
            WinnersView(
                winnersName: viewModel.winnersName ?? "",
                animate: $viewModel.animateWinner
            )
            .onChange(of: viewModel.ongoingGame.isFinished) { _, _ in
                viewModel.animateWinner = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.45, blendDuration: 0)) {
                        viewModel.animateWinner = true
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    func table(rounds: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header row
            HStack {
                Text("")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ForEach(viewModel.ongoingGame.players, id: \.id) { player in
                    Text(player.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // Single data row
            HStack {
                Text("Number of rounds won")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ForEach(viewModel.ongoingGame.players, id: \.id) { player in
                    quantityStepper(player: player)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 400)
        .padding()
        .disabled(viewModel.ongoingGame.isFinished && viewModel.hasUnsavedChanges == false)
    }
    
    @ViewBuilder
    func quantityStepper(player: Player) -> some View {
        HStack {
            Button(action: {
                self.viewModel.decrementRoundsWon(for: player)
            }) {
                Image(systemName: "minus.circle")
                    .foregroundColor(.blue)
            }
            //will be rounds won for player
            Text("\(viewModel.roundsWon[player.id] ?? "0")")
            Button(action: {
                self.viewModel.incrementRoundsWon(for: player)
            }) {
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
            }
        }
    }
}
