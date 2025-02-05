import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var images: [UIImage]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            PhotosPicker(
                selection: .init(get: { [] }, set: { items in
                    Task {
                        var loadedImages: [UIImage] = []
                        for item in items {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                loadedImages.append(uiImage)
                            }
                        }
                        images = loadedImages
                        dismiss()
                    }
                }),
                matching: .images
            ) {
                Text("Select Photos")
            }
        }
    }
} 