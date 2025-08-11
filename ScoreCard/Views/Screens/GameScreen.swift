import SwiftUI

struct GameScreen: View {
    
    let viewModel: ViewModel
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Game Screen")
    }
}
