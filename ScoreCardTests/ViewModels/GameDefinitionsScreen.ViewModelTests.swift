@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct GameDefinitionsScreenViewModelTests {
    @Test func testInitialization() {
        let coordinator = GameDefinitionsCoordinator(gameService: MockGameService(), playerService: MockPlayerService())
        let viewModel = GameDefinitionScreen.ViewModel(coordinator: coordinator, gameService: MockGameService())
        #expect(viewModel.games.isEmpty)
        #expect(viewModel.newGameName == "")
        #expect(viewModel.coordinator === coordinator)
    }
    
    @Test func testCreateGameCallsCoordinator() {
        class TestCoordinator: GameDefinitionsCoordinator {
            var didPresentSheet = false
            
            override func presentSheet(_ sheet: Sheet) {
                didPresentSheet = true
            }
        }
        let gameService = MockGameService()
        let coordinator = TestCoordinator(gameService: gameService, playerService: MockPlayerService())
        let viewModel = GameDefinitionScreen.ViewModel(coordinator: coordinator, gameService: gameService)
        viewModel.createGame()
        #expect(coordinator.didPresentSheet)
    }
    
    @Test func testDeleteCallsCoordinatorAndRefresh() {
        let gameService = MockGameService()
        gameService.returns.fetchData = [Game(name: "TestGame", ruleSet: .default)]
        let coordinator = GameDefinitionsCoordinator(gameService: gameService, playerService: MockPlayerService())
        let viewModel = GameDefinitionScreen.ViewModel(coordinator: coordinator, gameService: gameService)
        viewModel.refresh() // Load initial data
        viewModel.delete(at: IndexSet(integer: 0))
        #expect(gameService.invocations.delete.count == 1)
        #expect(viewModel.games.count == 0)
    }
    
    @Test func testShowGameCallsCoordinator() {
        
        let gameService = MockGameService()
        let coordinator = MockCoordinator()
        let viewModel = GameDefinitionScreen.ViewModel(coordinator: coordinator, gameService: gameService)
        let game = Game(name: "ShowMe", ruleSet: .default)
        viewModel.showGame(game)
        #expect(coordinator.invocations.push.count == 1)
    }
}
