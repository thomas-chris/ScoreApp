@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct GameDefinitionsCoordinatorTests {
    @Test func testInitialization() {
        
        let coordinator = GameDefinitionsCoordinator(gameService: MockGameService(), playerService: MockPlayerService())
        #expect(coordinator.gamesViewModel != nil)
        #expect(coordinator.path.count == 0)
        #expect(coordinator.sheet == nil)
    }
    
    @Test func testPushAndPopNavigation() {
        
        let coordinator = GameDefinitionsCoordinator(gameService: MockGameService(), playerService: MockPlayerService())
        coordinator.push(.home)
        #expect(coordinator.path.count == 1)
        coordinator.pop()
        #expect(coordinator.path.count == 0)
    }
    
    @Test func testPopToRootNavigation() {
        
        let coordinator = GameDefinitionsCoordinator(gameService: MockGameService(), playerService: MockPlayerService())
        coordinator.push(.home)
        coordinator.push(.gameDetail(Game(name: "Test", ruleSet: .default)))
        #expect(coordinator.path.count == 2)
        coordinator.popToRoot()
        #expect(coordinator.path.count == 0)
    }
    
    @Test func testSheetPresentationAndDismissal() {
        
        let coordinator = GameDefinitionsCoordinator(gameService: MockGameService(), playerService: MockPlayerService())
        coordinator.presentSheet(.createGame)
        #expect(coordinator.sheet == .createGame)
        coordinator.dismissSheet()
        #expect(coordinator.sheet == nil)
    }
    
    @Test func testShowGamePushesDetail() {
        let coordinator = GameDefinitionsCoordinator(gameService: MockGameService(), playerService: MockPlayerService())
        let game = Game(name: "DetailTest", ruleSet: .default)
        coordinator.showGame(game)
        #expect(coordinator.path.count == 1)
        // Optionally check that the last path element is .gameDetail(game)
    }
}
