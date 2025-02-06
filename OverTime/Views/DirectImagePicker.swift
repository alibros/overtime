import SwiftUI
import PhotosUI

struct DirectImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: SpacesViewModel
    let spaceId: UUID

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 0 // Allow multiple selections (set to 1 for single selection)
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: DirectImagePicker

        init(_ parent: DirectImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            let group = DispatchGroup()
            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        if let assetId = result.assetIdentifier {
                            let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                            if let asset = assetResults.firstObject {
                                let creationDate = asset.creationDate ?? Date()
                                DispatchQueue.main.async {
                                    if let url = self.parent.saveImageToDocuments(image: image) {
                                        let progressImage = ProgressImage(spaceId: self.parent.spaceId, imageUrl: url, date: creationDate)
                                        self.parent.viewModel.addImage(progressImage, to: self.parent.spaceId)
                                    }
                                }
                            }
                        }
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.parent.dismiss()
            }
        }
    }

    private func saveImageToDocuments(image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}

struct DirectImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        DirectImagePicker(images: .constant([]), spaceId: UUID())
            .environmentObject(SpacesViewModel())
    }
} 