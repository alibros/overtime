import SwiftUI

struct EditSpaceView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: SpacesViewModel
    let space: Space
    @State private var spaceName: String
    @State private var selectedColor: Color
    
    init(space: Space) {
        self.space = space
        _spaceName = State(initialValue: space.name)
        _selectedColor = State(initialValue: Color(hex: space.color))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Space Name", text: $spaceName)
                ColorPicker("Choose Color", selection: $selectedColor)
            }
            .navigationTitle("Edit Space")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Create an updated space and use view model to update.
                        var updatedSpace = space
                        updatedSpace.name = spaceName
                        updatedSpace.color = selectedColor.toHex() ?? space.color
                        viewModel.updateSpace(updatedSpace)
                        dismiss()
                    }
                    .disabled(spaceName.isEmpty)
                }
            }
        }
    }
}

struct EditSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        // Dummy data for preview purposes.
        let dummySpace = Space(name: "Gym", color: "#007AFF")
        EditSpaceView(space: dummySpace)
            .environmentObject(SpacesViewModel())
    }
} 