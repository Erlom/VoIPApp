//
//  StatusBadge.swift
//  VoIPApp
//

import SwiftUI

struct StatusBadge: View {

    let status: RegistrationStatus

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(status.label)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var color: Color {
        switch status {
        case .registered:   return .green
        case .registering:  return .orange
        case .failed:       return .red
        case .unregistered: return .gray
        }
    }
}
