//
//  VoIPAppApp.swift
//  VoIPApp
//

import SwiftUI

@main
struct VoIPAppApp: App {

    @State private var softphoneService = SoftphoneService(
        config: AppConfiguration(
            sip: SIPConfiguration(
                username: "3100",
                password: "misscom",
                server: "pbx.acrobits.cz"
            ),
            licenseKey: "kvotvlf5jgcsejqkc8bji3d90p"
        )
    )
    @State private var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(softphoneService)
                .environment(appSettings)
        }
    }
}
