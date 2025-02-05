import SwiftUI

struct ComparisonView: View {
    let spaceId: UUID
    @EnvironmentObject var viewModel: SpacesViewModel
    @State private var selectedImage1: ProgressImage?
    @State private var selectedImage2: ProgressImage?
    
    var body: some View {
        VStack {
            HStack {
                ImageComparisonCell(
                    image: selectedImage1,
                    images: viewModel.progressImages[spaceId] ?? [],
                    onSelect: { selectedImage1 = $0 }
                )
                
                ImageComparisonCell(
                    image: selectedImage2,
                    images: viewModel.progressImages[spaceId] ?? [],
                    onSelect: { selectedImage2 = $0 }
                )
            }
            .padding()
            
            if selectedImage1 != nil && selectedImage2 != nil {
                Text("\(daysBetween(selectedImage1!.date, selectedImage2!.date)) days difference")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Compare Progress")
    }
    
    private func daysBetween(_ date1: Date, _ date2: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date1, to: date2).day ?? 0
    }
} 