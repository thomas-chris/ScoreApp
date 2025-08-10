import SwiftUI

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var isPresentingAddGameAlert = false
        @Published var newGameName = ""
        let coordinator: Coordinator?
        
        init(coordinator: Coordinator?) {
            self.coordinator = coordinator
        }
        
        func createGame() {
            isPresentingAddGameAlert = true
        }
        
        func confirmAddGame() {
            let trimmedName = newGameName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty else { return }
            let game = Game(name: trimmedName)
            coordinator?.addGame(game)
            newGameName = ""
            isPresentingAddGameAlert = false
        }
        
        func cancelAddGame() {
            newGameName = ""
            isPresentingAddGameAlert = false
        }
        
        func showGame(_ game: Game) {
            coordinator?.showGame(game)
        }
        
        func delete(at offsets: IndexSet) {
            // implement delete logic if needed
        }
    }
}
