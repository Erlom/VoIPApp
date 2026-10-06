//
//  ContentView.swift
//  VoIPApp
//

import SwiftUI

struct ContentView: View {

    @Environment(SoftphoneService.self) private var softphoneService
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        switch softphoneService.registrationStatus {
        case .registered:
            TabView {
                Tab("Dialer", systemImage: "phone.fill") {
                    DialerView()
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView(settings: appSettings)
                }
            }
            .transition(.opacity)

        case .failed(let reason):
            ContentUnavailableView(
                "Registration Failed",
                systemImage: "phone.slash",
                description: Text(reason)
            )
            .transition(.opacity)

        default:
            VStack(spacing: 16) {
                ProgressView()
                Text("Connecting…")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .transition(.opacity)
        }
    }
}
