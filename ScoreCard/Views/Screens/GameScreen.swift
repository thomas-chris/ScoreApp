import SwiftUI

struct GameScreen: View {
    
    let viewModel: ViewModel
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
        VStack(alignment: .leading, spacing: 16) {
            Text("Rules")
                .font(.headline)
            
            Text(rulesDescription)
                
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
        ruleSet: RuleSet(gameType: .highScoreWins(100))
    )
    let viewModel = GameScreen.ViewModel(game: mockGame, coordinator: MainCoordinator(
        gameService : PreviewGameService(), playerService: PreviewPlayerService()))
    GameScreen(viewModel: viewModel)
}
