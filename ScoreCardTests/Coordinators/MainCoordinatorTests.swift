@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct MainCoordinatorTests {
    @Test func testInitialization() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let coordinator = MainCoordinator(gameService: MockGameService())
        #expect(coordinator.gamesViewModel != nil)
        #expect(coordinator.games.count == 0)
        #expect(coordinator.path.count == 0)
        #expect(coordinator.sheet == nil)
    }
    
    @Test func testPushAndPopNavigation() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let coordinator = MainCoordinator(gameService: MockGameService())
        coordinator.push(.home)
        #expect(coordinator.path.count == 1)
        coordinator.pop()
        #expect(coordinator.path.count == 0)
    }
    
    @Test func testPopToRootNavigation() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let coordinator = MainCoordinator(gameService: MockGameService())
        coordinator.push(.home)
        coordinator.push(.gameDetail(Game(name: "Test", ruleSet: .default)))
        #expect(coordinator.path.count == 2)
        coordinator.popToRoot()
        #expect(coordinator.path.count == 0)
    }
    
    @Test func testSheetPresentationAndDismissal() {
        let container = try! ModelContainer(for: Game.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        let coordinator = MainCoordinator(gameService: MockGameService())
        coordinator.presentSheet(.createGame)
        #expect(coordinator.sheet == .createGame)
        coordinator.dismissSheet()
        #expect(coordinator.sheet == nil)
    }
    
    @Test func testShowGamePushesDetail() {
        let coordinator = MainCoordinator(gameService: MockGameService())
        let game = Game(name: "DetailTest", ruleSet: .default)
        coordinator.showGame(game)
        #expect(coordinator.path.count == 1)
        // Optionally check that the last path element is .gameDetail(game)
    }
}
