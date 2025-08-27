import Foundation
import SwiftUI

enum Screen: Identifiable, Hashable {
    case home
    case gameDetail(Game)
    case players
    case ongoingGames
    
    var id: Self { return self }
}

enum Sheet: Identifiable, Hashable {
    case createGame
    case createPlayer
    
    var id: Self { return self }
}
