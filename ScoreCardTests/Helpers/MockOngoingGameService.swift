@testable import ScoreCard

class MockOngoingGameService: Service {
    func insert(_ item: ScoreCard.OngoingGame) {
        invocations.insert.append(item)
        returns.fetchData.append(item)
    }
    
    func delete(_ item: ScoreCard.OngoingGame) {
        invocations.delete.append(item)
        returns.fetchData.removeAll { $0.id == item.id }
    }
    
    func fetchData() -> [ScoreCard.OngoingGame] {
        invocations.fetchData += 1
        return returns.fetchData
    }
    
    typealias T = OngoingGame
    
    struct Invocations {
        var insert: [OngoingGame] = []
        var delete: [OngoingGame] = []
        var fetchData: Int = 0
    }
    
    struct Returns {
        var fetchData: [OngoingGame] = []
    }
    
    var invocations = Invocations()
    var returns = Returns()
}