import SwiftUI

struct FullScreenImageView: View {
    let progressImage: ProgressImage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Black background and centered image
            Color.black.ignoresSafeArea()
            
            AsyncImage(url: progressImage.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            
            // Close button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

struct FullScreenImageView_Previews: PreviewProvider {
    static var previews: some View {
        // Dummy data for preview
        let dummyProgressImage = ProgressImage(spaceId: UUID(), imageUrl: URL(string: "https://via.placeholder.com/600")!)
        FullScreenImageView(progressImage: dummyProgressImage)
    }
} 