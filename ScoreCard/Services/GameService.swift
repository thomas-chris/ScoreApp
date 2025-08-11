import Foundation
import SwiftData

protocol Service<T> {
    
    associatedtype T
    
    func insert(_ item: T)
    func delete(_ item: T)
    func fetchData() -> [T]
}

class GameService: Service {
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func insert(_ game: Game) {
        modelContext.insert(game)
        try? modelContext.save()
    }
    
    func delete(_ game: Game) {
        modelContext.delete(game)
        try? modelContext.save()
    }
    
    func fetchData() -> [Game] {
        do {
            let descriptor = FetchDescriptor<Game>(sortBy: [SortDescriptor(\.name)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
            return []
        }
    }
}

