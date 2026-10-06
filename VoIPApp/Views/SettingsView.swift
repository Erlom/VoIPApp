//
//  SettingsView.swift
//  VoIPApp
//

import SwiftUI

struct SettingsView: View {

    private let settings: AppSettings
    @State private var displayName: String
    @FocusState private var isFieldFocused: Bool

    init(settings: AppSettings) {
        self.settings = settings
        _displayName = State(initialValue: settings.displayName)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    LabeledContent("Display name") {
                        TextField("Enter value", text: $displayName)
                            .multilineTextAlignment(.trailing)
                            .focused($isFieldFocused)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        isFieldFocused = false
                        settings.displayName = displayName
                        settings.save()
                    }
                    .disabled(displayName.isEmpty)
                }
            }
        }
    }
}
