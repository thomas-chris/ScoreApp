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
    
    var addRowButton: some View {
        Button(action: {
            viewModel.addRound()
        }, label: {
            Image(systemName: "plus.circle")
        })
        .disabled(viewModel.hasUnsavedChanges || viewModel.ongoingGame.isFinished)
    }
    
    var body: some View {
        ScrollView {
            if viewModel.hasUnsavedChanges {
                Text("Warning - unsaved changes")
                    .foregroundColor(.red)
            }
            switch viewModel.ongoingGame.game.ruleSet.gameType {
                case .highScoreWins(let score),
                        .lowScoreWins(let score):
                    scoreWinsView(score: score)
                case .rounds(let rounds):
                    roundsView(rounds: rounds)
            }
            
        }
        .toolbar {
            if case .rounds = viewModel.ongoingGame.game.ruleSet.gameType {
                Button(action: {
                    viewModel.saveGame()
                }, label: {
                    saveImage
                })
            }
            if case .lowScoreWins = viewModel.ongoingGame.game.ruleSet.gameType {
                addRowButton
            }
            
            if case .highScoreWins = viewModel.ongoingGame.game.ruleSet.gameType {
                addRowButton
            }
            
        }
        .navigationTitle(viewModel.ongoingGame.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension OngoingGameDetailScreen {
    @ViewBuilder
    func winnersView() -> some View {
        
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
}

// MARK: - Rounds View

extension OngoingGameDetailScreen {
    
    @ViewBuilder
    func roundsView(rounds: Int) -> some View {
        roundsTable(rounds: rounds)
        winnersView()
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

// MARK: - Score Wins View

extension OngoingGameDetailScreen {
    @ViewBuilder
    func scoreWinsView(score: Int) -> some View {
        scoreTable(score: score)
        winnersView()
    }
    
    @ViewBuilder
    func scoreTable(score: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header row
            HStack {
                Text("Round")
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
            Divider()
            HStack {
                Text("Total")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ForEach(viewModel.ongoingGame.players.sorted(by: { player1, player2 in
                    player1.id.uuidString < player2.id.uuidString
                }), id: \.id) { player in
                    Text("\(viewModel.ongoingGame.scores[player.id] ?? 0)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func scoringRows() -> some View {
        ForEach(Array(viewModel.ongoingGame.scoringRounds.keys.sorted()), id: \.self) { key in
            HStack {
                Text("\(key)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                Divider()
                if let row = viewModel.ongoingGame.scoringRounds[key] {
                    scoringScores(row: row, key: key)
                }
                
            }
        }
    }
    
    @ViewBuilder
    func scoringScores(row: [UUID: String], key: Int) -> some View {
        
        ForEach(Array(row.keys.sorted()), id: \.self) { playerId in
            TextField("0", text:  binding(for: key, uuid: playerId))
                .frame(maxWidth: .infinity, alignment: .center)
                .onChange(of: binding(for: key, uuid: playerId).wrappedValue) { _, _ in
                    viewModel.updateScores()
                }
            Divider()
        }
    }
    
    private func binding(for key: Int, uuid: UUID) -> Binding<String> {
        return .init(
            get: { self.viewModel.ongoingGame.scoringRounds[key, default: [:]][uuid, default: "0"] },
            set: { self.viewModel.ongoingGame.scoringRounds[key]?[uuid] = $0 }
        )
    }
}
