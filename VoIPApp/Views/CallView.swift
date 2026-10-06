//
//  CallView.swift
//  VoIPApp
//

import SwiftUI

struct CallView: View {

    @Environment(SoftphoneService.self) private var softphoneService

    private var info: CallInfo? { softphoneService.activeCallInfo }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            avatar
                .padding(.bottom, 24)

            remotePartyLabel
                .padding(.bottom, 8)

            stateLabel

            Spacer()

            durationDisplay
                .padding(.bottom, 48)

            hangUpButton
                .padding(.bottom, 56)
        }
    }

    // MARK: - Components

    private var avatar: some View {
        Image(systemName: "person.circle.fill")
            .font(.system(size: 96))
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var remotePartyLabel: some View {
        if let info {
            Text(info.formattedDisplayName)
                .font(.title)
                .fontWeight(.semibold)
            if !info.displayName.isEmpty {
                Text(info.formattedNumber)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var stateLabel: some View {
        Text(callStateText)
            .font(.footnote)
            .foregroundStyle(.tertiary)
            .padding(.top, 4)
    }

    @ViewBuilder
    private var durationDisplay: some View {
        if info?.callState == .active, let start = info?.connectedAt {
            Text(start, style: .timer)
                .font(.system(.title2, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }

    private var hangUpButton: some View {
        CircleIconButton(color: .red, systemImage: "phone.down.fill", action: softphoneService.hangUp)
    }

    // MARK: - Helpers

    private var callStateText: String {
        switch info?.callState {
        case .connecting: return "Connecting…"
        case .ringing:    return "Ringing…"
        case .active:     return "Connected"
        case .held:       return "On hold"
        default:          return ""
        }
    }
}
