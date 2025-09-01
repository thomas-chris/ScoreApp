#if DEBUG
import Foundation

class PreviewPlayerService: Service {

    typealias T = Player
    
    func insert(_ item: ScoreCard.Player) {
        invocations.insert.append(item)
        returns.fetchData.append(item)
    }
    
    func delete(_ item: ScoreCard.Player) {
        invocations.delete.append(item)
        returns.fetchData.removeAll { $0.id == item.id }
    }
    
    func delete(with id: UUID) {
        invocations.deleteWithID.append(id)
    }
    
    func fetchData() -> [Player] {
        invocations.fetchData += 1
        return returns.fetchData
    }
    
    struct Invocations {
        var insert: [Player] = []
        var delete: [Player] = []
        var deleteWithID: [UUID] = []
        var fetchData: Int = 0
    }
    
    struct Returns {
        var fetchData: [Player] = [
            Player(name: "Alice"),
            Player(name: "Bob"),
            Player(name: "Charlie")
        ]
    }
    
    var invocations = Invocations()
    var returns = Returns()
}
#endif
