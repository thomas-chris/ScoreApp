import SwiftUI

struct MultiSelectDropdownMenu<T: HasName>: View {
    
    let viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { viewModel.isExpanded.toggle() }) {
                HStack {
                    Text(
                        viewModel.selectedOptions.wrappedValue.isEmpty
                            ? "Select options"
                            : viewModel.selectedOptions.wrappedValue.map { $0.name }.joined(separator: ", ")
                    )
                    Spacer()
                    Image(systemName: viewModel.isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            if viewModel.isExpanded {
                VStack {
                    ForEach(viewModel.options) { option in
                        HStack {
                            Text(option.name)
                            Spacer()
                            if viewModel.selectedOptions.wrappedValue.contains(option) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding()
                        .onTapGesture {
                            viewModel.didTap(option)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    MultiSelectDropdownMenu<Player>(
        viewModel: .init(options: [
            Player(name: "Alice"),
            Player(name: "Bob"),
            Player(name: "Charlie"),
            Player(name: "Diana")
        ], selectedOptions: .constant([]))
    )
}
