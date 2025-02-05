import SwiftUI

struct AddSpaceButton: View {
    @Binding var showingAddSpace: Bool
    
    var body: some View {
        Button(action: { showingAddSpace = true }) {
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 120)
                    .overlay {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                
                Text("New Space")
                    .font(.headline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
        }
        .foregroundColor(.primary)
    }
} 