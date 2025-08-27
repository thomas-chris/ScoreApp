@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct PlayersScreen_ViewModelTests {
    @Test func testInit() {
        let mockService = MockPlayerService()
        let coordinator = MockCoordinator()
        let viewModel = PlayersScreen.ViewModel(coordinator: coordinator, playerService: mockService)
        #expect(viewModel.playerService is MockPlayerService)
    }
    
    @Test func testCreatePlayer() {
        let mockService = MockPlayerService()
        let coordinator = MockCoordinator()
        let viewModel = PlayersScreen.ViewModel(coordinator: coordinator, playerService: mockService)
        
        viewModel.createPlayer()
        
        #expect(coordinator.invocations.presentSheet.count == 1)
        if case .createPlayer = coordinator.invocations.presentSheet.first {
            // Test passes - correct sheet was presented
        } else {
            #expect(Bool(false), "Expected createPlayer sheet to be presented")
        }
    }
    
    @Test func testDelete() {
        let mockService = MockPlayerService()
        let coordinator = MockCoordinator()
        let viewModel = PlayersScreen.ViewModel(coordinator: coordinator, playerService: mockService)
        
        let player1 = Player(name: "Alice", id: UUID())
        let player2 = Player(name: "Bob", id: UUID())
        let player3 = Player(name: "Charlie", id: UUID())
        
        viewModel.players = [player1, player2, player3]
        let offsetsToDelete = IndexSet([1]) // Delete Bob
        
        viewModel.delete(at: offsetsToDelete)
        
        #expect(mockService.invocations.delete.count == 1)
        #expect(mockService.invocations.delete.first?.name == "Bob")
        #expect(viewModel.players.count == 2)
        #expect(viewModel.players.contains { $0.name == "Alice" })
        #expect(viewModel.players.contains { $0.name == "Charlie" })
        #expect(!viewModel.players.contains { $0.name == "Bob" })
    }
    
    @Test func testShowPlayer() {
        let mockService = MockPlayerService()
        let coordinator = MockCoordinator()
        let viewModel = PlayersScreen.ViewModel(coordinator: coordinator, playerService: mockService)
        
        let player = Player(name: "TestPlayer", id: UUID())
        
        viewModel.showPlayer(player)
        
        #expect(coordinator.invocations.push.count == 1)
        if case .playerDetail(let pushedPlayer) = coordinator.invocations.push.first {
            #expect(pushedPlayer.name == "TestPlayer")
        } else {
            #expect(Bool(false), "Expected playerDetail screen to be pushed")
        }
    }
    
    @Test func testRefresh() {
        let mockService = MockPlayerService()
        let coordinator = MockCoordinator()
        let viewModel = PlayersScreen.ViewModel(coordinator: coordinator, playerService: mockService)
        
        let mockPlayers = [
            Player(name: "Player1", id: UUID()),
            Player(name: "Player2", id: UUID())
        ]
        mockService.returns.fetchData = mockPlayers
        
        viewModel.refresh()
        
        #expect(mockService.invocations.fetchData == 1)
        #expect(viewModel.players.count == 2)
        #expect(viewModel.players[0].name == "Player1")
        #expect(viewModel.players[1].name == "Player2")
    }
}
