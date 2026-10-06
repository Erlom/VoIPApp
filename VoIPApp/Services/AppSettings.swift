//
//  AppSettings.swift
//  VoIPApp
//

import Foundation

/// Persists user-configurable preferences to UserDefaults.
/// Observed by the Settings and Dialer screens via the @Observable macro.
@Observable
final class AppSettings {

    private enum Keys {
        static let displayName = "user.displayName"
    }

    /// Local user display name shown on the Dialer screen.
    /// An empty string means no name is configured and the label is hidden.
    var displayName: String

    init() {
        displayName = UserDefaults.standard.string(forKey: Keys.displayName) ?? ""
    }

    /// Persists the current display name to UserDefaults.
    func save() {
        UserDefaults.standard.set(displayName, forKey: Keys.displayName)
    }
}
