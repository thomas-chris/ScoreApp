import SwiftData
import SwiftUI
import Combine

class MainCoordinator: AppCoordinator {
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.path = NavigationPath()
        self.contentViewModel = ContentView.ViewModel(coordinator: self)
    }
    
    var modelContext: ModelContext
    let parentCoordinator: (any AppCoordinator)? = nil
    var games = [Game]() {
        didSet {
            contentViewModel?.games = games
        }
    }
    
    @Published var contentViewModel: ContentView.ViewModel?
    @Published var path: NavigationPath
    @Published var sheet: Sheet?
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func showGame(_ game: Game) {
        
    }
    
    func add(game: Game) {
        modelContext.insert(game)
        fetchData()
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let game = games[offset]
            modelContext.delete(game)
        }
        games.remove(atOffsets: offsets)
        try? modelContext.save()
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

extension MainCoordinator {
    // MARK: - Presentation Style Providers
    @ViewBuilder
    func build(_ screen: Screen) -> some View {
        switch screen {
            case .home:
                ContentView(viewModel: contentViewModel)
            case .gameDetail(named: let game):
                EmptyView() // Replace with actual game view
        }
    }
    
    @ViewBuilder
    func build(_ sheet: Sheet) -> some View {
        switch sheet {
            case Sheet.createGame:
                AddGameSheet(viewModel: .init(coordinator: self))
        }
    }
}
