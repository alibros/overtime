import SwiftUI
import PhotosUI

struct DirectImagePicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Environment(\.dismiss) private var dismiss

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
            var loadedImages: [UIImage] = []
            let group = DispatchGroup()
            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    defer { group.leave() }
                    if let image = object as? UIImage {
                        loadedImages.append(image)
                    }
                }
            }
            group.notify(queue: .main) {
                self.parent.images = loadedImages
                self.parent.dismiss()
            }
        }
    }
}

struct DirectImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        DirectImagePicker(images: .constant([]))
    }
} 