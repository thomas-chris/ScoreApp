import SwiftData
import SwiftUI
import Combine

class Coordinator: ObservableObject {
    @Published var selectedGame: Game?
    @Published var games = [Game]()
    @Published var contentViewModel: ContentView.ViewModel?
    @Published var isPresentingAddGameAlert = false
    @Published var newGameName = ""
    
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.contentViewModel = ContentView.ViewModel(coordinator: self)
    }
    
    func showGame(_ game: Game) {
        selectedGame = game
    }
    
    func addGame() {
        isPresentingAddGameAlert = true
    }
    
    func confirmAddGame() {
        let trimmedName = newGameName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        let game = Game(name: trimmedName)
        add(game: game)
        newGameName = ""
        isPresentingAddGameAlert = false
    }
    
    func add(game: Game) {
        modelContext.insert(game)
        fetchData()
    }
    
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<Game>(sortBy: [SortDescriptor(\.name)])
            games = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
}
