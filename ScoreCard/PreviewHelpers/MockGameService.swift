#if DEBUG
class PreviewGameService: Service {
    func insert(_ item: ScoreCard.Game) {
        invocations.insert.append(item)
        returns.fetchData.append(item)
    }
    
    func delete(_ item: ScoreCard.Game) {
        invocations.delete.append(item)
        returns.fetchData.removeAll { $0.id == item.id }
    }
    
    func fetchData() -> [ScoreCard.Game] {
        invocations.fetchData += 1
        return returns.fetchData
    }
    
    typealias T = Game
    
    struct Invocations {
        var insert: [Game] = []
        var delete: [Game] = []
        var fetchData: Int = 0
    }
    
    struct Returns {
        var fetchData: [Game] = []
    }
    
    var invocations = Invocations()
    var returns = Returns()
}
#endif
