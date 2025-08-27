@testable import ScoreCard
import SwiftUI

class MockCoordinator: AppCoordinator {
    
    var path: NavigationPath
    var sheet: ScoreCard.Sheet?
    var parentCoordinator: (any ScoreCard.AppCoordinator)?

    init() {
        self.path = NavigationPath()
        self.sheet = nil
        self.parentCoordinator = nil
    }
    struct Invocations {
        var push: [Screen] = []
        var presentSheet: [Sheet] = []
        var pop: Int = 0
        var popToRoot: Int = 0
        var dismissSheet: Int = 0
        var showGame: [Game] = []
        var showPlayer: [Player] = []
        var switchTab: [Int] = []
        var buildScreen: [Screen] = []
        var buildSheet: [Sheet] = []
    }
    
    var invocations = Invocations()
    
    func push(_ screen: Screen) {
        invocations.push.append(screen)
    }
    func presentSheet(_ sheet: Sheet) {
        invocations.presentSheet.append(sheet)
    }
    func pop() {
        invocations.pop += 1
    }
    func popToRoot() {
        invocations.popToRoot += 1
    }
    func dismissSheet() {
        invocations.dismissSheet += 1
    }
    func switchTab(_ index: Int) {
        invocations.switchTab.append(index)
    }
}
