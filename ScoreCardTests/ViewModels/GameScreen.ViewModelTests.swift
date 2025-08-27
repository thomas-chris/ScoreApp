@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct GameScreen_ViewModelTests {
    @Test func testInit() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let viewModel = GameScreen.ViewModel(game: mockGame, coordinator: MockCoordinator(), playerService: MockPlayerService())
        #expect(viewModel.game.name == "Test")
    }
    
    @Test func testTogglePlayerAddsIfNotSelected() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let mockPlayer = Player(name: "Alice", id: UUID())
        let viewModel = GameScreen.ViewModel(game: mockGame, coordinator: MockCoordinator(), playerService: MockPlayerService())
        #expect(!viewModel.selectedPlayers.contains(mockPlayer))
        viewModel.toggle(mockPlayer)
        #expect(viewModel.selectedPlayers.contains(mockPlayer))
    }
    
    @Test func testTogglePlayerRemovesIfSelected() {
        let mockGame = Game(name: "Test", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4))
        let mockPlayer = Player(name: "Bob", id: UUID())
        let viewModel = GameScreen.ViewModel(game: mockGame, coordinator: MockCoordinator(), playerService: MockPlayerService())
        viewModel.selectedPlayers.insert(mockPlayer)
        #expect(viewModel.selectedPlayers.contains(mockPlayer))
        viewModel.toggle(mockPlayer)
        #expect(!viewModel.selectedPlayers.contains(mockPlayer))
    }
    // Add more tests for public methods as needed
}

