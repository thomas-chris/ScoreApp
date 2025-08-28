import SwiftUI

protocol AppCoordinator: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var parentCoordinator: (any AppCoordinator)? { get }
    
    func push(_ screen:  Screen)
    func presentSheet(_ sheet: Sheet)
    func pop()
    func popToRoot()
    func dismissSheet()
    func switchTab(_ index: Int)
}
