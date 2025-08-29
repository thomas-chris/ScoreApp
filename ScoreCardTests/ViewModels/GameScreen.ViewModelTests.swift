@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct GameScreen_ViewModelTests {
    @Test func testInit() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        #expect(viewModel.game.name == "Test")
    }
    
    @Test func testTogglePlayerAddsIfNotSelected() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let mockPlayer = Player(name: "Alice", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        #expect(!viewModel.selectedPlayers.contains(mockPlayer))
        viewModel.toggle(mockPlayer)
        #expect(viewModel.selectedPlayers.contains(mockPlayer))
    }
    
    @Test func testTogglePlayerRemovesIfSelected() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let mockPlayer = Player(name: "Bob", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        viewModel.selectedPlayers.insert(mockPlayer)
        #expect(viewModel.selectedPlayers.contains(mockPlayer))
        viewModel.toggle(mockPlayer)
        #expect(!viewModel.selectedPlayers.contains(mockPlayer))
    }
    
    @Test func testIsInGameReturnsTrueForSelectedPlayer() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let mockPlayer = Player(name: "Alice", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        
        viewModel.selectedPlayers.insert(mockPlayer)
        
        #expect(viewModel.isInGame(mockPlayer) == true)
    }
    
    @Test func testIsInGameReturnsFalseForUnselectedPlayer() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let mockPlayer = Player(name: "Alice", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        
        #expect(viewModel.isInGame(mockPlayer) == false)
    }
    
    @Test func testCanStartGameReturnsTrueWithValidPlayerCount() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let player1 = Player(name: "Alice", id: UUID())
        let player2 = Player(name: "Bob", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        
        viewModel.selectedPlayers.insert(player1)
        viewModel.selectedPlayers.insert(player2)
        
        #expect(viewModel.canStartGame == true)
    }
    
    @Test func testCanStartGameReturnsFalseWithTooFewPlayers() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let player1 = Player(name: "Alice", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        
        viewModel.selectedPlayers.insert(player1)
        
        #expect(viewModel.canStartGame == false)
    }
    
    @Test func testCanStartGameReturnsFalseWithTooManyPlayers() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let player1 = Player(name: "Alice", id: UUID())
        let player2 = Player(name: "Bob", id: UUID())
        let player3 = Player(name: "Charlie", id: UUID())
        let player4 = Player(name: "David", id: UUID())
        let player5 = Player(name: "Eve", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        
        viewModel.selectedPlayers.insert(player1)
        viewModel.selectedPlayers.insert(player2)
        viewModel.selectedPlayers.insert(player3)
        viewModel.selectedPlayers.insert(player4)
        viewModel.selectedPlayers.insert(player5)
        
        #expect(viewModel.canStartGame == false)
    }
    
    @Test func testStartGame() {
        let mockGame = Game(name: "Test Game", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let player1 = Player(name: "Alice", id: UUID())
        let player2 = Player(name: "Bob", id: UUID())
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: MockPlayerService(),
            ongoingGameService: MockOngoingGameService()
        )
        
        viewModel.selectedPlayers.insert(player1)
        viewModel.selectedPlayers.insert(player2)
        
        // Since startGame() currently only prints, we just verify it doesn't crash
        viewModel.startGame()
        
        // Verify the selected players are still there after calling startGame
        #expect(viewModel.selectedPlayers.contains(player1))
        #expect(viewModel.selectedPlayers.contains(player2))
    }
    
    @Test func testRefreshPlayers() {
        let mockPlayerService = MockPlayerService()
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        
        let initialPlayers = [
            Player(name: "Initial1", id: UUID()),
            Player(name: "Initial2", id: UUID())
        ]
        mockPlayerService.returns.fetchData = initialPlayers
        
        let viewModel = GameScreen.ViewModel(
            game: mockGame,
            coordinator: MockCoordinator(),
            playerService: mockPlayerService,
            ongoingGameService: MockOngoingGameService()
        )
        
        let newPlayers = [
            Player(name: "New1", id: UUID()),
            Player(name: "New2", id: UUID()),
            Player(name: "New3", id: UUID())
        ]
        mockPlayerService.returns.fetchData = newPlayers
        
        viewModel.refreshPlayers()
        
        #expect(mockPlayerService.invocations.fetchData == 2) // Once in init, once in refreshPlayers
        #expect(viewModel.players.count == 3)
        #expect(viewModel.players[0].name == "New1")
        #expect(viewModel.players[1].name == "New2")
        #expect(viewModel.players[2].name == "New3")
    }
}
