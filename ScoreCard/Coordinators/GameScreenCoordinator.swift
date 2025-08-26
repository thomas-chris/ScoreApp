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
        parentCoordinator?.push(screen)
    }

    func presentSheet(_ sheet: Sheet) {
        parentCoordinator?.presentSheet(sheet)
    }

    func pop() {
        parentCoordinator?.pop()
    }

    func popToRoot() {
        parentCoordinator?.popToRoot()
    }

    func dismissSheet() {
        parentCoordinator?.dismissSheet()
    }
    
    func switchTab(_ index: Int) {
        parentCoordinator?.switchTab(index)
    }

}
