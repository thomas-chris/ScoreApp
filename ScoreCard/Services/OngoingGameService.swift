import Foundation
import SwiftData

class OngoingGameService: Service {
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func insert(_ game: OngoingGame) {
        modelContext.insert(game)
        try? modelContext.save()
    }
    
    func delete(_ game: OngoingGame) {
        modelContext.delete(game)
        try? modelContext.save()
    }
    
    func fetchData() -> [OngoingGame] {
        do {
            let descriptor = FetchDescriptor<OngoingGame>(sortBy: [SortDescriptor(\.name)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
            return []
        }
    }
}

