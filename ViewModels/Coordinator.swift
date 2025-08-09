import SwiftUI
import Combine

class Coordinator: ObservableObject {
    @Published var selectedGame: Game?
    
    func showGame(_ game: Game) {
        selectedGame = game
    }
    
    func addGame(viewModel: ViewModel) {
        viewModel.addGame()
    }
}
