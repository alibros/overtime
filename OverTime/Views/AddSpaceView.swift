import SwiftUI

struct AddSpaceView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: SpacesViewModel
    @State private var spaceName = ""
    @State private var selectedColor = Color.blue
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Space Name", text: $spaceName)
                
                ColorPicker("Choose Color", selection: $selectedColor)
            }
            .navigationTitle("New Space")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let space = Space(
                            name: spaceName,
                            color: selectedColor.toHex() ?? "#007AFF"
                        )
                        viewModel.addSpace(space)
                        dismiss()
                    }
                    .disabled(spaceName.isEmpty)
                }
            }
        }
    }
} 