import SwiftUI

struct ImageComparisonCell: View {
    let image: ProgressImage?
    let images: [ProgressImage]
    let onSelect: (ProgressImage) -> Void
    
    var body: some View {
        VStack {
            if let image = image {
                AsyncImage(url: image.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Menu {
                    ForEach(images) { img in
                        Button(img.date.formatted()) {
                            onSelect(img)
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(height: 200)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                        }
                }
            }
        }
    }
} 