import SwiftUI

struct CollapsableHeaderSection: View {
    
    let title: String
    @Binding var sectionExpanded: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: sectionExpanded ? "chevron.down" : "chevron.right")
                .onTapGesture {
                    sectionExpanded.toggle()
                }
            
        }
    }
}
