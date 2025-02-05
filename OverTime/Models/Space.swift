import SwiftUI

struct Space: Identifiable, Codable {
    let id: UUID
    var name: String
    var createdAt: Date
    var color: String // We'll store color as a hex string
    
    init(id: UUID = UUID(), name: String, color: String) {
        self.id = id
        self.name = name
        self.createdAt = Date()
        self.color = color
    }
} 