//
//  VoIPAppApp.swift
//  VoIPApp
//

import SwiftUI

@main
struct VoIPAppApp: App {

    private let softphoneService: SoftphoneService
    private let appSettings = AppSettings()
    private let dialerViewModel: DialerViewModel

    init() {
        let service = SoftphoneService(
            config: AppConfiguration(
                sip: SIPConfiguration(
                    username: "3100",
                    password: "misscom",
                    server: "pbx.acrobits.cz"
                ),
                licenseKey: "kvotvlf5jgcsejqkc8bji3d90p"
            )
        )
        softphoneService = service
        dialerViewModel = DialerViewModel(service: service)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(softphoneService)
                .environment(appSettings)
                .environment(dialerViewModel)
        }
    }
}
