import SwiftUI

class MainCoordinator: AppCoordinator {
    @Published var path: NavigationPath
    @Published var sheet: Sheet?
    var parentCoordinator: (any AppCoordinator)?
    
    init(parentCoordinator: (any AppCoordinator)? = nil) {
        self.path = NavigationPath()
        self.parentCoordinator = parentCoordinator
    }
    
    func dismissSheet() {
        
    }
    
    func switchTab(_ index: Int) {
        
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

