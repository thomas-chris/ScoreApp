import SwiftUI

struct RadioButton: View {
    
    @State var isSelected: Bool = false
    let label: String
    var toggleAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 12, height: 12)
                    }
                }
                .onTapGesture {
                    isSelected.toggle()
                    toggleAction?()
                }
                Text(label)
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    RadioButton(label: "Option 1")
}
