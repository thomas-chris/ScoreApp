import SwiftUI

struct WinnersView: View {
    let winnersName: String
    @Binding var animate: Bool
    
    var body: some View {
        ZStack {
            Image(systemName: "crown.fill")
                .resizable()
                .foregroundStyle(.yellow)
                .frame(width: 150, height: 150)
            VStack {
                Text("Game Finished")
                    .font(.title)
                    .foregroundColor(.green)
                Text("Winner: \(winnersName)")
                    .font(.title)
                    .foregroundColor(.green)
            }
            
        }
        .scaleEffect(animate ? 1 : 0.05)
        .opacity(animate ? 1 : 0)
        .rotationEffect(animate ? .degrees(0) : .degrees(120))
        .animation(.spring(response: 0.45, dampingFraction: 0.45, blendDuration: 0), value: animate)
        .onAppear {
            animate = true
        }
        .onDisappear {
            animate = false
        }
    }
}
