//
//  AddPlayerSheet.ViewModelTests.swift
//  ScoreCard
//
//  Created by Chris Thomas on 28/08/2025.
//

@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct AddPlayerSheetViewModelTests {
    
    @Test func testInitialization() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        #expect(viewModel.playerService is MockPlayerService)
        #expect(viewModel.coordinator is MockCoordinator)
        #expect(viewModel.newPlayerName == "")
    }
    
    @Test func testAddPlayerWithValidData() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        // Set up test data
        viewModel.newPlayerName = "Test Player"
        
        viewModel.add()
        
        // Verify player was inserted
        #expect(mockPlayerService.invocations.insert.count == 1)
        let insertedPlayer = mockPlayerService.invocations.insert.first!
        #expect(insertedPlayer.name == "Test Player")
        
        // Verify coordinator dismissed sheet
        #expect(mockCoordinator.invocations.dismissSheet == 1)
    }
    
    @Test func testAddPlayerWithWhitespaceInName() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        // Set up test data with whitespace
        viewModel.newPlayerName = "  Test Player  "
        
        viewModel.add()
        
        // Verify player name is trimmed
        #expect(mockPlayerService.invocations.insert.count == 1)
        let insertedPlayer = mockPlayerService.invocations.insert.first!
        #expect(insertedPlayer.name == "Test Player")
        
        // Verify coordinator dismissed sheet
        #expect(mockCoordinator.invocations.dismissSheet == 1)
    }
    
    @Test func testAddPlayerWithEmptyName() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        // Set up test data with empty name
        viewModel.newPlayerName = ""
        
        viewModel.add()
        
        // Verify player was still inserted (even with empty name)
        #expect(mockPlayerService.invocations.insert.count == 1)
        let insertedPlayer = mockPlayerService.invocations.insert.first!
        #expect(insertedPlayer.name == "")
        
        // Verify coordinator dismissed sheet
        #expect(mockCoordinator.invocations.dismissSheet == 1)
    }
    
    @Test func testAddPlayerWithOnlyWhitespace() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        // Set up test data with only whitespace
        viewModel.newPlayerName = "   "
        
        viewModel.add()
        
        // Verify player name is trimmed to empty string
        #expect(mockPlayerService.invocations.insert.count == 1)
        let insertedPlayer = mockPlayerService.invocations.insert.first!
        #expect(insertedPlayer.name == "")
        
        // Verify coordinator dismissed sheet
        #expect(mockCoordinator.invocations.dismissSheet == 1)
    }
    
    @Test func testAddPlayerWithSpecialCharacters() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        // Set up test data with special characters
        viewModel.newPlayerName = "Test Player 123!@#"
        
        viewModel.add()
        
        // Verify player was inserted with special characters preserved
        #expect(mockPlayerService.invocations.insert.count == 1)
        let insertedPlayer = mockPlayerService.invocations.insert.first!
        #expect(insertedPlayer.name == "Test Player 123!@#")
        
        // Verify coordinator dismissed sheet
        #expect(mockCoordinator.invocations.dismissSheet == 1)
    }
    
    @Test func testAddPlayerWithLongName() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        // Set up test data with a very long name
        let longName = String(repeating: "A", count: 100)
        viewModel.newPlayerName = longName
        
        viewModel.add()
        
        // Verify player was inserted with long name
        #expect(mockPlayerService.invocations.insert.count == 1)
        let insertedPlayer = mockPlayerService.invocations.insert.first!
        #expect(insertedPlayer.name == longName)
        
        // Verify coordinator dismissed sheet
        #expect(mockCoordinator.invocations.dismissSheet == 1)
    }
    
    @Test func testDismissAlert() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        viewModel.dismissAlert()
        
        #expect(mockCoordinator.invocations.dismissSheet == 1)
        #expect(mockPlayerService.invocations.insert.count == 0) // No player should be inserted
    }
    
    @Test func testMultipleAdds() {
        let mockPlayerService = MockPlayerService()
        let mockCoordinator = MockCoordinator()
        let viewModel = AddPlayerSheet.ViewModel(coordinator: mockCoordinator, playerService: mockPlayerService)
        
        // Add first player
        viewModel.newPlayerName = "Player 1"
        viewModel.add()
        
        // Add second player
        viewModel.newPlayerName = "Player 2"
        viewModel.add()
        
        // Verify both players were inserted
        #expect(mockPlayerService.invocations.insert.count == 2)
        #expect(mockPlayerService.invocations.insert[0].name == "Player 1")
        #expect(mockPlayerService.invocations.insert[1].name == "Player 2")
        
        // Verify coordinator dismissed sheet twice
        #expect(mockCoordinator.invocations.dismissSheet == 2)
    }
}
