//
//  ContentView.swift
//  VoIPApp
//

import SwiftUI

struct ContentView: View {

    @Environment(SoftphoneService.self) private var softphoneService
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        if case .failed(let reason) = softphoneService.registrationStatus {
            ContentUnavailableView(
                "Registration Failed",
                systemImage: "phone.slash",
                description: Text(reason)
            )
        } else {
            TabView {
                Tab("Dialer", systemImage: "phone.fill") {
                    DialerView()
                }
                Tab("Settings", systemImage: "gear") {
                    SettingsView(settings: appSettings)
                }
            }
            .fullScreenCover(isPresented: Binding(
                get: { softphoneService.activeCallInfo != nil },
                set: { _ in }
            )) {
                CallView()
            }
        }
    }
}
