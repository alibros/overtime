import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SpacesViewModel()
    @State private var showingAddSpace = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(viewModel.spaces) { space in
                        NavigationLink(destination: SpaceDetailView(space: space)) {
                            SpaceCard(space: space)
                        }
                    }
                    
                    AddSpaceButton(showingAddSpace: $showingAddSpace)
                }
                .padding()
            }
            .navigationTitle("Progress Spaces")
            .sheet(isPresented: $showingAddSpace) {
                AddSpaceView()
            }
        }
        .environmentObject(viewModel)
    }
}

struct SpaceCard: View {
    let space: Space
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: space.color))
                .frame(height: 120)
                .overlay {
                    // Show the latest image if available
                }
            
            Text(space.name)
                .font(.headline)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
} 