import SwiftData
import SwiftUI

extension PlayersScreen {
    @Observable
    class ViewModel {
        
        var players: [Player] = []
        weak var coordinator: (any AppCoordinator)?
        let playerService: any Service<Player>
        
        init(
            coordinator: any AppCoordinator,
            playerService: any Service<Player>
        ) {
            self.coordinator = coordinator
            self.playerService = playerService
        }
        
        func createPlayer() {
            coordinator?.presentSheet(.createPlayer)
        }
        
        func delete(at offsets: IndexSet) {
            for offset in offsets {
                let player = players[offset]
                playerService.delete(player)
            }
            players.remove(atOffsets: offsets)
        }
        
        func showPlayer(_ player: Player) {
            coordinator?.push(.playerDetail(player))
        }
        
        func refresh() {
            players = playerService.fetchData()
        }
    }
}
