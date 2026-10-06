//
//  ContentView.swift
//  VoIPApp
//

import SwiftUI

struct ContentView: View {

    @Environment(SoftphoneService.self) private var softphoneService

    var body: some View {
        VStack(spacing: 16) {
            if let error = softphoneService.initializationError {
                Text("SDK init failed: \(error.localizedDescription)")
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            } else {
                Text("Registration: \(softphoneService.registrationStatus.label)")
                    .font(.headline)
            }
        }
        .padding()
    }
}
