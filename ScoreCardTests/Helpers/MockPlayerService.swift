@testable import ScoreCard

class MockPlayerService: Service {
    func insert(_ item: ScoreCard.Player) {
        invocations.insert.append(item)
        returns.fetchData.append(item)
    }
    
    func delete(_ item: ScoreCard.Player) {
        invocations.delete.append(item)
        returns.fetchData.removeAll { $0.id == item.id }
    }
    
    func fetchData() -> [ScoreCard.Player] {
        invocations.fetchData += 1
        return returns.fetchData
    }
    
    typealias T = Player
    
    struct Invocations {
        var insert: [Player] = []
        var delete: [Player] = []
        var fetchData: Int = 0
    }
    
    struct Returns {
        var fetchData: [Player] = []
    }
    
    var invocations = Invocations()
    var returns = Returns()
}
