import SwiftData
import SwiftUI
import Combine

class GameScreenCoordinator: AppCoordinator {
    var path: NavigationPath
    var sheet: Sheet?
    var parentCoordinator: (any AppCoordinator)?

    init(path: NavigationPath, parentCoordinator: (any AppCoordinator)? = nil) {
        self.path = path
        self.parentCoordinator = parentCoordinator
    }
    
    func push(_ screen: Screen) {
        
    }

    func presentSheet(_ sheet: Sheet) {
    
    }

    func pop() {
        
    }

    func popToRoot() {
        
    }

    func dismissSheet() {
        
    }
}
