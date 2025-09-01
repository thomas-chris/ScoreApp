#if DEBUG
import Foundation

class PreviewOngoingGameService: Service {
    
    typealias T = OngoingGame
    
    func insert(_ item: ScoreCard.OngoingGame) {
        invocations.insert.append(item)
        returns.fetchData.append(item)
    }
    
    func delete(_ item: ScoreCard.OngoingGame) {
        invocations.delete.append(item)
        returns.fetchData.removeAll { $0.id == item.id }
    }
    
    func delete(with id: UUID) {
        invocations.deleteWithID.append(id)
    }
    
    func fetchData() -> [OngoingGame] {
        invocations.fetchData += 1
        return returns.fetchData
    }
    
    struct Invocations {
        var insert: [OngoingGame] = []
        var delete: [OngoingGame] = []
        var deleteWithID: [UUID] = []
        var fetchData: Int = 0
    }
    
    struct Returns {
        init() {
            
            let players = [
                Player(name: "Alice"),
                Player(name: "Bob")
            ]
            
            let scores = players.reduce(into: [UUID: Int]()) { dict, player in
                dict[player.id] = 0
            }
            
            self.fetchData = [
                OngoingGame(
                    name: "Chess - Game 2",
                    game: .init(name: "Chess", ruleSet: .init(gameType: .rounds(1), minNumberOfPlayers: 2, maxNumberOfPlayers: 2)),
                    players: players,
                    scores: scores,
                    roundsPlayed: 0
                ),
                OngoingGame(
                    name: "Chess - Game 1",
                    game: .init(name: "Chess", ruleSet: .init(gameType: .rounds(1), minNumberOfPlayers: 2, maxNumberOfPlayers: 2)),
                    players: players,
                    scores: scores,
                    roundsPlayed: 1
                ),
                OngoingGame(
                    name: "Dominoes",
                    game: .init(
                        name: "Dominoes",
                        ruleSet: .init(
                            gameType: .lowScoreWins(50),
                            minNumberOfPlayers: 2,
                            maxNumberOfPlayers: 8
                        )
                    ),
                    players: players,
                    scores: scores,
                    roundsPlayed: 0
                )
            ]
        }
        
        var fetchData: [OngoingGame]
    }
    
    var invocations = Invocations()
    var returns = Returns()
}
#endif
