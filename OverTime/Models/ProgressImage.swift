import SwiftUI

struct ProgressImage: Identifiable, Codable {
    let id: UUID
    let spaceId: UUID
    let imageUrl: URL
    let date: Date
    var note: String?
    
    init(id: UUID = UUID(), spaceId: UUID, imageUrl: URL, note: String? = nil) {
        self.id = id
        self.spaceId = spaceId
        self.imageUrl = imageUrl
        self.date = Date()
        self.note = note
    }
} 