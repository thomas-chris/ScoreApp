@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct HomeScreenViewModelTests {
    @Test func testInitialization() {
        let coordinator = MainCoordinator(modelContext: ModelContext(try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator)
        #expect(viewModel.games.isEmpty)
        #expect(viewModel.newGameName == "")
        #expect(viewModel.coordinator === coordinator)
    }
    
    @Test func testCreateGameCallsCoordinator() {
        class TestCoordinator: MainCoordinator {
            var didPresentSheet = false
            override func presentSheet(_ sheet: Sheet) {
                didPresentSheet = true
            }
        }
        let coordinator = TestCoordinator(modelContext: ModelContext(try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator)
        viewModel.createGame()
        #expect(coordinator.didPresentSheet)
    }
    
    @Test func testDeleteCallsCoordinatorAndRefresh() {
        class TestCoordinator: MainCoordinator {
            var didDelete = false
            override func delete(at offsets: IndexSet) {
                didDelete = true
            }
            override func fetchData() {
                games = [Game(name: "TestGame", ruleSet: .default)]
            }
        }
        let coordinator = TestCoordinator(modelContext: ModelContext(try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator)
        viewModel.delete(at: IndexSet(integer: 0))
        #expect(coordinator.didDelete)
        #expect(viewModel.games.count == 1)
        #expect(viewModel.games.first?.name == "TestGame")
    }
    
    @Test func testShowGameCallsCoordinator() {
        class TestCoordinator: MainCoordinator {
            var didShowGame = false
            override func showGame(_ game: Game) {
                didShowGame = true
            }
        }
        let coordinator = TestCoordinator(modelContext: ModelContext(try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator)
        let game = Game(name: "ShowMe", ruleSet: .default)
        viewModel.showGame(game)
        #expect(coordinator.didShowGame)
    }
    
    @Test func testRefreshUpdatesGamesFromCoordinator() {
        let coordinator = MainCoordinator(modelContext: ModelContext(try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))))
        
        coordinator.add(game: Game(name: "A", ruleSet: .default))
        coordinator.add(game: Game(name: "B", ruleSet: .default))
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator)
        viewModel.refresh()
        #expect(viewModel.games.count == 2)
        #expect(viewModel.games.map { $0.name }.contains("A"))
        #expect(viewModel.games.map { $0.name }.contains("B"))
    }
}
