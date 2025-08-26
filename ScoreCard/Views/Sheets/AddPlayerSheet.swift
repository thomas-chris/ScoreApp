import SwiftUI
import SwiftData
struct AddPlayerSheet: View {
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        VStack(
            spacing: 20
        ) {
            Text(
                "Add Player"
            )
            .font(
                .headline
            )
        
            TextField(
                "Player Name",
                text: $viewModel.newPlayerName
            )
            .textFieldStyle(
                RoundedBorderTextFieldStyle()
            )
            .padding()
            HStack {
                Spacer()
                Button(
                    "Cancel"
                ) {
                    viewModel
                        .dismissAlert()
                }
                Spacer()
                Button(
                    "Add"
                ) {
                    viewModel.add()
                }
                .disabled(
                    viewModel.newPlayerName.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
                Spacer()
                
            }
        }
        .padding()
        .presentationDetents(
            [.medium]
        )
    }
}

#Preview {
    Group {
        if let container = try? ModelContainer(
            for: Game.self
        ) {
            let viewModel = AddPlayerSheet.ViewModel(
                coordinator: PlayerCoordinator(
                    gameService: PreviewGameService(),
                    playerService: PreviewPlayerService()
                ),
                playerService: PreviewPlayerService()
            )
            AddPlayerSheet(
                viewModel: viewModel
            )
        } else {
            AnyView(
                Text(
                    "Model container not available"
                )
            )
        }
    }
}
