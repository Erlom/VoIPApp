//
//  DialerKey.swift
//  VoIPApp
//

import SwiftUI

struct DialerKey: View {

    let label: String
    let action: () -> Void
    var longPressAction: (() -> Void)? = nil

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 80, height: 80)
                .overlay {
                    VStack(spacing: 1) {
                        Text(label)
                            .font(.system(size: 28, weight: .regular))
                            .foregroundStyle(.primary)
                        if longPressAction != nil {
                            Text("+")
                                .font(.system(size: 10, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
        }
        .buttonStyle(DialerKeyButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in longPressAction?() }
        )
    }
}

struct DialerKeyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
