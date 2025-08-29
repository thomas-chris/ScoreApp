@testable import ScoreCard
import SwiftUI
import SwiftData
import Testing

struct OngoingGamesScreen_ViewModelTests {
    
    @Test func testInit() {
        let mockService = MockOngoingGameService()
        let coordinator = MockCoordinator()
        let viewModel = OngoingGamesScreen.ViewModel(coordinator: coordinator, ongoingGameService: mockService)
        
        #expect(viewModel.ongoingGameService is MockOngoingGameService)
        #expect(viewModel.coordinator is MockCoordinator)
        #expect(viewModel.games.isEmpty)
    }
    
    @Test func testOngoingGamesFilterNonFinishedGames() {
        let mockService = MockOngoingGameService()
        let coordinator = MockCoordinator()
        let viewModel = OngoingGamesScreen.ViewModel(coordinator: coordinator, ongoingGameService: mockService)
        
        let player1 = Player(name: "Alice")
        let player2 = Player(name: "Bobbie")
        
        let ongoingGame1 = OngoingGame(
            name: "Game1",
            game: Game(
                name: "Game1",
                ruleSet: RuleSet(
                    gameType: .highScoreWins(10),
                    minNumberOfPlayers: 2,
                    maxNumberOfPlayers: 4
                )
            ),
            players: [player1, player2],
            scores: [:],
            roundsPlayed: 0
        )
        let ongoingGame2 = OngoingGame(
            name: "Game2",
            game: Game(name: "Game2", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4)),
            players: [player1, player2],
            scores: [:],
            roundsPlayed: 0
        )
        let finishedGame = OngoingGame(
            name: "FinishedGame",
            game: Game(
                name: "FinishedGame",
                ruleSet: RuleSet(
                    gameType: .highScoreWins(10),
                    minNumberOfPlayers: 2,
                    maxNumberOfPlayers: 4
                )
            ),
            players: [player1, player2],
            scores: [
                player1.id: 10,
                player2.id: 5
            ],
            roundsPlayed: 15
        )
        
        viewModel.games = [ongoingGame1, finishedGame, ongoingGame2]
        
        #expect(viewModel.ongoingGames.count == 2)
        #expect(viewModel.ongoingGames.contains { $0.game.name == "Game1" })
        #expect(viewModel.ongoingGames.contains { $0.game.name == "Game2" })
        #expect(!viewModel.ongoingGames.contains { $0.game.name == "FinishedGame" })
    }
    
    @Test func testCompletedGamesFilterFinishedGames() {
        let mockService = MockOngoingGameService()
        let coordinator = MockCoordinator()
        let viewModel = OngoingGamesScreen.ViewModel(coordinator: coordinator, ongoingGameService: mockService)
        
        let player1 = Player(name: "Alice")
        let player2 = Player(name: "Bobbie")
        
        let ongoingGame = OngoingGame(
            name: "OngoingGame",
            game: Game(
                name: "OngoingGame",
                ruleSet: RuleSet(
                    gameType: .highScoreWins(
                        10
                    ),
                    minNumberOfPlayers: 2,
                    maxNumberOfPlayers: 4
                )
            ),
            players: [player1, player2],
            scores: [
                player1.id: 4,
                player2.id: 2
            ],
            roundsPlayed: 0
        )
        let finishedGame1 = OngoingGame(
            name: "FinishedGame1",
            game: Game(
                name: "FinishedGame1",
                ruleSet: RuleSet(
                    gameType: .highScoreWins(
                        10
                    ),
                    minNumberOfPlayers: 2,
                    maxNumberOfPlayers: 4
                )
            ),
            players: [player1, player2],
            scores: [
                player1.id: 11,
                player2.id: 7
            ],
            roundsPlayed: 15
        )
        let finishedGame2 = OngoingGame(
            name: "FinishedGame2",
            game: Game(
                name: "FinishedGame2",
                ruleSet: RuleSet(
                    gameType: .rounds(
                        15
                    ),
                    minNumberOfPlayers: 2,
                    maxNumberOfPlayers: 4
                )
            ),
            players: [player1, player2],
            scores: [:],
            roundsPlayed: 15
        )
        
        viewModel.games = [ongoingGame, finishedGame1, finishedGame2]
        
        #expect(viewModel.completedGames.count == 2)
        #expect(viewModel.completedGames.contains { $0.game.name == "FinishedGame1" })
        #expect(viewModel.completedGames.contains { $0.game.name == "FinishedGame2" })
        #expect(!viewModel.completedGames.contains { $0.game.name == "OngoingGame" })
    }
    
    @Test func testOngoingGamesEmptyWhenAllGamesFinished() {
        let mockService = MockOngoingGameService()
        let coordinator = MockCoordinator()
        let viewModel = OngoingGamesScreen.ViewModel(coordinator: coordinator, ongoingGameService: mockService)
        let player1 = Player(name: "Alice")
        let player2 = Player(name: "Bobbie")
        
        let finishedGame1 = OngoingGame(
            name: "FinishedGame1",
            game: Game(name: "FinishedGame1", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4)),
            players: [player1, player2],
            scores: [
                player1.id: 12,
                player2.id: 8
            ],
            roundsPlayed: 15
        )
        let finishedGame2 = OngoingGame(
            name: "FinishedGame2",
            game: Game(name: "FinishedGame2", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4)),
            players: [],
            scores: [
                player1.id:10,
                player2.id:5
                ],
            roundsPlayed: 15
        )
        
        viewModel.games = [finishedGame1, finishedGame2]
        
        #expect(viewModel.ongoingGames.isEmpty)
        #expect(viewModel.completedGames.count == 2)
    }
    
    @Test func testCompletedGamesEmptyWhenAllGamesOngoing() {
        let mockService = MockOngoingGameService()
        let coordinator = MockCoordinator()
        let viewModel = OngoingGamesScreen.ViewModel(coordinator: coordinator, ongoingGameService: mockService)
        
        let ongoingGame1 = OngoingGame(
            name: "OngoingGame1",
            game: Game(name: "OngoingGame1", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4)),
            players: [],
            scores: [:],
            roundsPlayed: 0
        )
        let ongoingGame2 = OngoingGame(
            name: "OngoingGame2",
            game: Game(name: "OngoingGame2", ruleSet: RuleSet(gameType: .highScoreWins(10), minNumberOfPlayers: 2, maxNumberOfPlayers: 4)),
            players: [],
            scores: [:],
            roundsPlayed: 0
        )
        
        viewModel.games = [ongoingGame1, ongoingGame2]
        
        #expect(viewModel.completedGames.isEmpty)
        #expect(viewModel.ongoingGames.count == 2)
    }
    
    @Test func testRefresh() {
        let mockService = MockOngoingGameService()
        let coordinator = MockCoordinator()
        let viewModel = OngoingGamesScreen.ViewModel(coordinator: coordinator, ongoingGameService: mockService)
        
        let mockGames = [
            OngoingGame(
                name: "Game1",
                game: Game(
                    name: "Game1",
                    ruleSet: RuleSet(
                        gameType: .highScoreWins(10),
                        minNumberOfPlayers: 2,
                        maxNumberOfPlayers: 4
                    )
                ),
                players: [],
                scores: [:],
                roundsPlayed: 0
            ),
            OngoingGame(
                name: "Game2",
                game: Game(
                    name: "Game2",
                    ruleSet: RuleSet(
                        gameType: .highScoreWins(10),
                        minNumberOfPlayers: 2,
                        maxNumberOfPlayers: 4
                    )
                ),
                players: [],
                scores: [:],
                roundsPlayed: 15
            )
        ]
        mockService.returns.fetchData = mockGames
        
        viewModel.refresh()
        
        #expect(mockService.invocations.fetchData == 1)
        #expect(viewModel.games.count == 2)
        #expect(viewModel.games[0].game.name == "Game1")
        #expect(viewModel.games[1].game.name == "Game2")
    }
    
    @Test func testRefreshEmptyData() {
        let mockService = MockOngoingGameService()
        let coordinator = MockCoordinator()
        let viewModel = OngoingGamesScreen.ViewModel(coordinator: coordinator, ongoingGameService: mockService)
        
        // Start with some games
        viewModel.games = [OngoingGame(
            name: "ExistingGame",
            game: Game(
                name: "ExistingGame",
                ruleSet: RuleSet(
                    gameType: .highScoreWins(10),
                    minNumberOfPlayers: 2,
                    maxNumberOfPlayers: 4
                )
            ),
            players: [],
            scores: [:],
            roundsPlayed: 0
        )]
        
        // Service returns empty array
        mockService.returns.fetchData = []
        
        viewModel.refresh()
        
        #expect(mockService.invocations.fetchData == 1)
        #expect(viewModel.games.isEmpty)
        #expect(viewModel.ongoingGames.isEmpty)
        #expect(viewModel.completedGames.isEmpty)
    }
}
