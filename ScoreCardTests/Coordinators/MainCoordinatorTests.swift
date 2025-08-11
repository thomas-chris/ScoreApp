@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct MainCoordinatorTests {
    @Test func testInitialization() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        #expect(coordinator.contentViewModel != nil)
        #expect(coordinator.games.count == 0)
        #expect(coordinator.path.count == 0)
        #expect(coordinator.sheet == nil)
    }
    
    @Test func testPushAndPopNavigation() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        coordinator.push(.home)
        #expect(coordinator.path.count == 1)
        coordinator.pop()
        #expect(coordinator.path.count == 0)
    }
    
    @Test func testPopToRootNavigation() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        coordinator.push(.home)
        coordinator.push(.gameDetail(Game(name: "Test", ruleSet: .default)))
        #expect(coordinator.path.count == 2)
        coordinator.popToRoot()
        #expect(coordinator.path.count == 0)
    }
    
    @Test func testSheetPresentationAndDismissal() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        coordinator.presentSheet(.createGame)
        #expect(coordinator.sheet == .createGame)
        coordinator.dismissSheet()
        #expect(coordinator.sheet == nil)
    }
    
    @Test func testAddGame() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        let game = Game(name: "Test Game", ruleSet: .default)
        coordinator.add(game: game)
        #expect(coordinator.games.contains(where: { $0.name == "Test Game" }))
    }
    
    @Test func testDeleteGame() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        let game1 = Game(name: "Game 1", ruleSet: .default)
        let game2 = Game(name: "Game 2", ruleSet: .default)
        coordinator.add(game: game1)
        coordinator.add(game: game2)
        #expect(coordinator.games.count == 2)
        coordinator.delete(at: IndexSet(integer: 0))
        #expect(coordinator.games.count == 1)
        #expect(!coordinator.games.contains(where: { $0.name == "Game 1" }))
    }
    
    @Test func testFetchData() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        let game = Game(name: "FetchTest", ruleSet: .default)
        coordinator.add(game: game)
        coordinator.games.removeAll()
        coordinator.fetchData()
        #expect(coordinator.games.contains(where: { $0.name == "FetchTest" }))
    }
    
    @Test func testShowGamePushesDetail() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let modelContext = ModelContext(container)
        let coordinator = MainCoordinator(gameService: MockGameService())
        let game = Game(name: "DetailTest", ruleSet: .default)
        coordinator.showGame(game)
        #expect(coordinator.path.count == 1)
        // Optionally check that the last path element is .gameDetail(game)
    }
}
