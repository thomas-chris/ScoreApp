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
                case .lowScoreWins(let score):
                    lowScoreWinsView(score: score)
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
            
            if case .lowScoreWins = viewModel.ongoingGame.game.ruleSet.gameType {
                Button(action: {
                    viewModel.addRound()
                }, label: {
                    Image(systemName: "plus.circle")
                })
            }
            
        }
        .navigationTitle(viewModel.ongoingGame.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension OngoingGameDetailScreen {
    
    
    
}

// MARK: - Rounds View

extension OngoingGameDetailScreen {
    
    @ViewBuilder
    func roundsView(rounds: Int) -> some View {
        roundsTable(rounds: rounds)
        
        
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
    func roundsTable(rounds: Int) -> some View {
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

// MARK: - High Score Wins View

extension OngoingGameDetailScreen {
    var highScoreWinsView: some View {
        Text("High Score Wins View")
    }
}

// MARK: - Low Score Wins View

extension OngoingGameDetailScreen {
    @ViewBuilder
    func lowScoreWinsView(score: Int) -> some View {
        scoreTable(score: score)
    }
    
    @ViewBuilder
    func scoreTable(score: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header row
            HStack {
                Text("")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ForEach(viewModel.ongoingGame.players.sorted(by: { player1, player2 in
                    player1.id.uuidString < player2.id.uuidString
                }), id: \.id) { player in
                    Text(player.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                }
            }
            Divider()
            scoringRows()
            
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func scoringRows() -> some View {
        ForEach(Array(viewModel.scoringRounds.keys.sorted()), id: \.self) { key in
            HStack {
                Text("Round \(key)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                Divider()
                scoringScores(key: key)
                
            }
        }
    }
    
    @ViewBuilder
    func scoringScores(key: Int) -> some View {
        ForEach(Array(viewModel.scoringRounds[key]?.keys.sorted() ?? []), id: \.self) { playerId in
            Text("\(viewModel.scoringRounds[key]?[playerId] ?? 3)" )
                .frame(maxWidth: .infinity, alignment: .center)
            Divider()
        }
    }
    
}
