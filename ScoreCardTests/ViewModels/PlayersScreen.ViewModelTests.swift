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
    // Add more tests for public methods as needed
}
