import Foundation
import SwiftData

@Model class Game {
    
    @Attribute(.unique) var id: UUID
    var name: String
    
    init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }
    
}
