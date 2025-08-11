import SwiftUI
import SwiftData
struct AddGameSheet: View {
    @Bindable var viewModel: ViewModel
    
    var subtitle: String {
        switch viewModel.gameType {
            case .highScoreWins:
                return "Winning Score:"
            case .lowScoreWins:
                return "Losing Score:"
            case .rounds:
                return "Number of Rounds:"
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Game")
                .font(.headline)
            Picker("Game Type", selection: $viewModel.gameType) {
                Text("High Score Wins").tag(AddGameSheet.ViewModel.GameType.highScoreWins)
                Text("Low Score Wins").tag(AddGameSheet.ViewModel.GameType.lowScoreWins)
                Text("Rounds").tag(AddGameSheet.ViewModel.GameType.rounds)
            }
            .pickerStyle(SegmentedPickerStyle())
            TextField("Game Name", text: $viewModel.newGameName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Text(subtitle)
                    .font(.subheadline)
                    .padding(.horizontal)
                TextField("Value", value: $viewModel.value, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
            }
            .padding()
            HStack {
                Spacer()
                Button("Cancel") {
                    viewModel.dismissAlert()
                }
                Spacer()
                Button("Add") {
                    viewModel.add()
                }
                .disabled(viewModel.newGameName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Spacer()
                    
            }
        }
        .padding()
        .presentationDetents([.medium])
    }
}

#Preview {
    Group {
        if let container = try? ModelContainer(for: Game.self) {
            let viewModel = AddGameSheet.ViewModel(
                coordinator: MainCoordinator(
                    gameService: GameService(
                        modelContext: ModelContext(container)
                    )
                )
            )
            AddGameSheet(viewModel: viewModel)
        } else {
            AnyView(Text("Model container not available"))
        }
    }
}
