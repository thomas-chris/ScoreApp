@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct HomeScreenViewModelTests {
    @Test func testInitialization() {
        let coordinator = GameCoordinator(gameService: MockGameService())
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator, gameService: MockGameService())
        #expect(viewModel.games.isEmpty)
        #expect(viewModel.newGameName == "")
        #expect(viewModel.coordinator === coordinator)
    }
    
    @Test func testCreateGameCallsCoordinator() {
        class TestCoordinator: GameCoordinator {
            var didPresentSheet = false
            override func presentSheet(_ sheet: Sheet) {
                didPresentSheet = true
            }
        }
        let gameService = MockGameService()
        let coordinator = TestCoordinator(gameService: gameService)
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator, gameService: gameService)
        viewModel.createGame()
        #expect(coordinator.didPresentSheet)
    }
    
    @Test func testDeleteCallsCoordinatorAndRefresh() {
        let gameService = MockGameService()
        gameService.returns.fetchData = [Game(name: "TestGame", ruleSet: .default)]
        let coordinator = GameCoordinator(gameService: gameService)
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator, gameService: gameService)
        viewModel.refresh() // Load initial data
        viewModel.delete(at: IndexSet(integer: 0))
        #expect(gameService.invocations.delete.count == 1)
        #expect(viewModel.games.count == 0)
    }
    
    @Test func testShowGameCallsCoordinator() {
        class TestCoordinator: GameCoordinator {
            var didShowGame = false
            override func showGame(_ game: Game) {
                didShowGame = true
            }
        }
        let gameService = MockGameService()
        let coordinator = TestCoordinator(gameService: gameService)
        let viewModel = HomeScreen.ViewModel(coordinator: coordinator, gameService: gameService)
        let game = Game(name: "ShowMe", ruleSet: .default)
        viewModel.showGame(game)
        #expect(coordinator.didShowGame)
    }
}
