@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct AddGameSheetViewModelTests {
    
    @Test func testInitialization() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        #expect(viewModel.gameService is MockGameService)
        #expect(viewModel.coordinator is MockCoordinator)
        #expect(viewModel.newGameName == "")
        #expect(viewModel.minNumberOfPlayers == "2")
        #expect(viewModel.maxNumberOfPlayers == "8")
        #expect(viewModel.gameType == .highScoreWins)
        #expect(viewModel.value == 0)
    }
    
    @Test func testAddGameWithValidData() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        // Set up test data
        viewModel.newGameName = "Test Game"
        viewModel.minNumberOfPlayers = "2"
        viewModel.maxNumberOfPlayers = "4"
        viewModel.gameType = .highScoreWins
        viewModel.value = 100
        
        viewModel.add()
        
        // Verify game was inserted
        #expect(mockGameService.invocations.insert.count == 1)
        let insertedGame = mockGameService.invocations.insert.first!
        #expect(insertedGame.name == "Test Game")
        #expect(insertedGame.ruleSet.minNumberOfPlayers == 2)
        #expect(insertedGame.ruleSet.maxNumberOfPlayers == 4)
        
        // Verify coordinator dismissed sheet
        #expect(mockCoordinator.invocations.dismissSheet == 1)
    }
    
    @Test func testAddGameWithWhitespaceInName() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        // Set up test data with whitespace
        viewModel.newGameName = "  Test Game  "
        viewModel.minNumberOfPlayers = "3"
        viewModel.maxNumberOfPlayers = "6"
        viewModel.gameType = .lowScoreWins
        viewModel.value = 50
        
        viewModel.add()
        
        // Verify game name is trimmed
        #expect(mockGameService.invocations.insert.count == 1)
        let insertedGame = mockGameService.invocations.insert.first!
        #expect(insertedGame.name == "Test Game")
        #expect(insertedGame.ruleSet.minNumberOfPlayers == 3)
        #expect(insertedGame.ruleSet.maxNumberOfPlayers == 6)
    }
    
    @Test func testAddGameWithInvalidPlayerNumbers() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        // Set up test data with invalid numbers
        viewModel.newGameName = "Test Game"
        viewModel.minNumberOfPlayers = "invalid"
        viewModel.maxNumberOfPlayers = "also invalid"
        viewModel.gameType = .rounds
        viewModel.value = 10
        
        viewModel.add()
        
        // Verify defaults are used when conversion fails
        #expect(mockGameService.invocations.insert.count == 1)
        let insertedGame = mockGameService.invocations.insert.first!
        #expect(insertedGame.name == "Test Game")
        #expect(insertedGame.ruleSet.minNumberOfPlayers == 2) // Default value
        #expect(insertedGame.ruleSet.maxNumberOfPlayers == 8) // Default value
    }
    
    @Test func testAddGameWithHighScoreWinsType() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        viewModel.newGameName = "High Score Game"
        viewModel.gameType = .highScoreWins
        viewModel.value = 500
        
        viewModel.add()
        
        #expect(mockGameService.invocations.insert.count == 1)
        let insertedGame = mockGameService.invocations.insert.first!
        // Note: Would need to check the actual gameType conversion logic
        #expect(insertedGame.name == "High Score Game")
    }
    
    @Test func testAddGameWithLowScoreWinsType() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        viewModel.newGameName = "Low Score Game"
        viewModel.gameType = .lowScoreWins
        viewModel.value = 20
        
        viewModel.add()
        
        #expect(mockGameService.invocations.insert.count == 1)
        let insertedGame = mockGameService.invocations.insert.first!
        #expect(insertedGame.name == "Low Score Game")
    }
    
    @Test func testAddGameWithRoundsType() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        viewModel.newGameName = "Rounds Game"
        viewModel.gameType = .rounds
        viewModel.value = 5
        
        viewModel.add()
        
        #expect(mockGameService.invocations.insert.count == 1)
        let insertedGame = mockGameService.invocations.insert.first!
        #expect(insertedGame.name == "Rounds Game")
    }
    
    @Test func testDismissAlert() {
        let mockGameService = MockGameService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddGameSheet.ViewModel(coordinator: mockCoordinator, gameService: mockGameService)
        
        viewModel.dismissAlert()
        
        #expect(mockCoordinator.invocations.dismissSheet == 1)
        #expect(mockGameService.invocations.insert.count == 0) // No game should be inserted
    }
}
