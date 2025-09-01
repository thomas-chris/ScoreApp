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
    
    func delete(with id: UUID) {
        try? modelContext.delete(model: OngoingGame.self, where: #Predicate { game in
            game.id == id
        })
        try? modelContext.save()
    }
    
    func fetchData() -> [OngoingGame] {
        do {
            let descriptor = FetchDescriptor<OngoingGame>(sortBy: [SortDescriptor(\.id)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
            return []
        }
    }
}
