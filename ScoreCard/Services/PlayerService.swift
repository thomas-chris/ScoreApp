import Foundation
import SwiftData

class PlayerService: Service {
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func insert(_ player: Player) {
        modelContext.insert(player)
        try? modelContext.save()
    }
    
    func delete(_ player: Player) {
        modelContext.delete(player)
        try? modelContext.save()
    }
    
    func fetchData() -> [Player] {
        do {
            let descriptor = FetchDescriptor<Player>(sortBy: [SortDescriptor(\.name)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
            return []
        }
    }
}

