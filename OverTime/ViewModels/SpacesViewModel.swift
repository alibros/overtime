import SwiftUI

class SpacesViewModel: ObservableObject {
    @Published var spaces: [Space] = []
    @Published var progressImages: [UUID: [ProgressImage]] = [:] // Organized by space ID
    
    init() {
        loadData()
    }
    
    func addSpace(_ space: Space) {
        spaces.append(space)
        progressImages[space.id] = []
        saveData()
    }
    
    func addImage(_ image: ProgressImage, to spaceId: UUID) {
        if progressImages[spaceId] != nil {
            progressImages[spaceId]?.append(image)
        } else {
            progressImages[spaceId] = [image]
        }
        saveData()
    }
    
    func updateSpace(_ updatedSpace: Space) {
        if let index = spaces.firstIndex(where: { $0.id == updatedSpace.id }) {
            spaces[index] = updatedSpace
        }
    }
    
    private func loadData() {
        // Implementation for loading from UserDefaults or FileManager
    }
    
    private func saveData() {
        // Implementation for saving to UserDefaults or FileManager
    }
} 