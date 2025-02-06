import SwiftUI
import PhotosUI

struct SpaceDetailView: View {
    let space: Space
    @EnvironmentObject var viewModel: SpacesViewModel
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImages: [UIImage] = []
    @State private var showingComparisonView = false
    @State private var selectedFullScreenImage: ProgressImage? = nil
    @State private var showingEditSpace = false
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with actions
                HStack {
                    Button(action: { showingCamera = true }) {
                        ActionButton(
                            icon: "camera.fill",
                            title: "Take Photo"
                        )
                    }
                    
                    Button(action: { showingImagePicker = true }) {
                        ActionButton(
                            icon: "photo.on.rectangle",
                            title: "Choose Photo"
                        )
                    }
                    
                    Button(action: { showingComparisonView = true }) {
                        ActionButton(
                            icon: "square.split.2x1",
                            title: "Compare"
                        )
                    }
                }
                .padding()
                
                // Timeline of images as a grid
                let columns: [GridItem] = [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ]
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(sortedImages) { progressImage in
                        ZStack(alignment: .topTrailing) {
                            ProgressImageCard(progressImage: progressImage)
                                .onTapGesture {
                                    if !isEditing {
                                        selectedFullScreenImage = progressImage
                                    }
                                }
                            
                            if isEditing {
                                Button(action: {
                                    deleteImage(progressImage)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding(8)
                                        .background(Color.white.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                .padding(6)
                            }
                        }
                    }
                }
                .padding([.horizontal, .bottom], 16)
            }
        }
        .navigationTitle(space.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: { showingEditSpace = true }) {
                        Image(systemName: "gearshape")
                    }
                    Button(action: { isEditing.toggle() }) {
                        Text(isEditing ? "Done" : "Edit")
                    }
                }
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(image: $selectedImages)
        }
        .sheet(isPresented: $showingImagePicker) {
            DirectImagePicker(images: $selectedImages, spaceId: space.id)
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingComparisonView) {
            ComparisonView(spaceId: space.id)
        }
        .sheet(isPresented: $showingEditSpace) {
            EditSpaceView(space: space)
        }
        .fullScreenCover(item: $selectedFullScreenImage) { progressImage in
            FullScreenImageView(progressImage: progressImage)
        }
        .onChange(of: selectedImages) { newImages in
            for image in newImages {
                if let url = saveImageToDocuments(image: image) {
                    let progressImage = ProgressImage(spaceId: space.id, imageUrl: url, date: Date())
                    viewModel.addImage(progressImage, to: space.id)
                }
            }
            selectedImages = []
        }
    }
    
    private var sortedImages: [ProgressImage] {
        viewModel.progressImages[space.id]?.sorted(by: { $0.date < $1.date }) ?? []
    }
    
    private func deleteImage(_ progressImage: ProgressImage) {
        if let index = viewModel.progressImages[space.id]?.firstIndex(where: { $0.id == progressImage.id }) {
            viewModel.progressImages[space.id]?.remove(at: index)
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

    struct SpaceDetailView_Previews: PreviewProvider {
        static var previews: some View {
            // Create dummy data for preview
            let dummySpace = Space(name: "Test Space", color: "#FF5733")
            let viewModel = SpacesViewModel()
            viewModel.spaces = [dummySpace]
            viewModel.progressImages[dummySpace.id] = [
                ProgressImage(
                    spaceId: dummySpace.id,
                    imageUrl: URL(string: "https://via.placeholder.com/150")!,
                    date: Date(),
                    note: "Test"
                )
            ]
            return NavigationStack {
                SpaceDetailView(space: dummySpace)
            }
            .environmentObject(viewModel)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 24))
            Text(title)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 
