import SwiftUI

struct GameScreen: View {
    
    @Bindable var viewModel: ViewModel
    @State private var playersSectionExpanded: Bool = true
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var rulesDescription: String {
        switch viewModel.game.ruleSet.gameType {
            case .highScoreWins(let score):
                return "First to \(score) wins"
            case .lowScoreWins(let score):
                return "Game ends when someone reaches \(score)"
            case .rounds(let rounds):
                return "\(rounds) rounds"
        }
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Rules")
                    .font(.headline)
                ) {
                    Text(rulesDescription)
                    Text("Min Players: \(viewModel.game.ruleSet.minNumberOfPlayers)")
                    Text("Max Players: \(viewModel.game.ruleSet.maxNumberOfPlayers)")
                }
                
                Section(isExpanded: $playersSectionExpanded) {
                    ForEach(viewModel.players, id: \.id) { player in
                        RadioButton(
                            label: player.name,
                            toggleAction: {
                                viewModel.toggle(player)
                            }
                        )
                    }
                } header: {
                    HStack {
                        CollapsableHeaderSection(
                            title: "Players",
                            sectionExpanded: $playersSectionExpanded
                        )
                        
                    }
                }
            }
            Button("Start Game") {
                viewModel.startGame()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.canStartGame)
        }
        .onAppear {
            viewModel.refreshPlayers()
        }
        .navigationTitle(viewModel.game.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

import SwiftUI
import SwiftData

#Preview {
    let mockGame = Game(
        name: "Test Game",
        ruleSet: RuleSet(
            gameType: .highScoreWins(100),
            minNumberOfPlayers: 2,
            maxNumberOfPlayers: 8
        )
    )
    let viewModel = GameScreen.ViewModel(
        game: mockGame,
        coordinator: GameDefinitionsCoordinator(
            gameService : PreviewGameService(),
            playerService: PreviewPlayerService(), ongoingGameService: PreviewOngoingGameService()),
        playerService: PreviewPlayerService(), ongoingGameService: PreviewOngoingGameService()
    )
    GameScreen(viewModel: viewModel)
}
