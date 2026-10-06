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
        CircleButton(
            color: Color(.systemGray5),
            action: action,
            longPressAction: longPressAction
        ) {
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
}
