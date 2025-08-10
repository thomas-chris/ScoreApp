import Foundation
import SwiftUI

enum Screen: Identifiable, Hashable {
    case home
    case gameDetail(Game)
    
    var id: Self { return self }
}

enum Sheet: Identifiable, Hashable {
    case createGame
    
    var id: Self { return self }
}
