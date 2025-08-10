import SwiftUI
struct AddGameSheet: View {
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Game")
                .font(.headline)
            TextField("Game Name", text: $viewModel.newGameName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                Spacer()
                    .disabled(viewModel.newGameName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding()
        .presentationDetents([.medium])
    }
}
