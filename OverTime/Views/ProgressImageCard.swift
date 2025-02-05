import SwiftUI

struct ProgressImageCard: View {
    let progressImage: ProgressImage
    
    var formattedDate: String {
        progressImage.date.formatted(date: .abbreviated, time: .shortened)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: progressImage.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 150)
            .clipped()
            
            VStack(alignment: .trailing, spacing: 4) {
                if let note = progressImage.note {
                    Text(note)
                        .font(.caption2)
                        .padding(4)
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                Text(formattedDate)
                    .font(.caption2)
                    .padding(4)
                    .background(Color.black.opacity(0.5))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(6)
        }
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

//struct ActionButton: View {
//    let icon: String
//    let title: String
//    let accentColor: Color
//
//    var body: some View {
//        VStack {
//            Image(systemName: icon)
//                .font(.system(size: 24))
//                .foregroundColor(accentColor)
//            Text(title)
//                .font(.caption)
//                .foregroundColor(accentColor)
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//    }
//}

struct ProgressImageCard_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy progress image for preview purposes.
        let dummyProgressImage = ProgressImage(
            spaceId: UUID(),
            imageUrl: URL(string: "https://via.placeholder.com/150")!,
            note: "Sample Note"
        )
        return ProgressImageCard(progressImage: dummyProgressImage)
            .previewLayout(.sizeThatFits)
            .padding()
    }
} 
