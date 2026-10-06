//
//  DialerView.swift
//  VoIPApp
//

import SwiftUI

struct DialerView: View {

    @Environment(SoftphoneService.self) private var softphoneService
    @Environment(AppSettings.self) private var settings

    @State private var dialString: String = ""

    private let keypad: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["*", "0", "#"]
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            numberDisplay
            keypadGrid
            actionRow
            Spacer()
        }
        .padding(.horizontal, 32)
        .overlay(alignment: .topTrailing) {
            VStack(alignment: .trailing, spacing: 4) {
                StatusBadge(status: softphoneService.registrationStatus)
                if !settings.displayName.isEmpty {
                    Text(settings.displayName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
    }

    // MARK: - Components

    private var numberDisplay: some View {
        Text(dialString.isEmpty ? "Enter number" : dialString)
            .font(.system(size: 34, weight: .light, design: .monospaced))
            .foregroundStyle(dialString.isEmpty ? .tertiary : .primary)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
    }

    private var keypadGrid: some View {
        VStack(spacing: 16) {
            ForEach(keypad, id: \.self) { row in
                HStack(spacing: 20) {
                    ForEach(row, id: \.self) { key in
                        DialerKey(
                            label: key,
                            action: { dialString.append(key) },
                            longPressAction: key == "0" ? { dialString.append("+") } : nil
                        )
                    }
                }
            }
        }
    }

    private var actionRow: some View {
        HStack(spacing: 20) {
            Color.clear.frame(width: 80, height: 80)

            CircleIconButton(
                color: canCall ? .green : Color(.systemGray3),
                systemImage: "phone.fill",
                action: { softphoneService.call(number: dialString) }
            )
            .disabled(!canCall)

            Button {
                guard !dialString.isEmpty else { return }
                dialString.removeLast()
            } label: {
                Image(systemName: "delete.backward")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
            .opacity(dialString.isEmpty ? 0.3 : 1)
            .disabled(dialString.isEmpty)
            .frame(width: 80, height: 80)
        }
        .padding(.top, 8)
    }

    private var canCall: Bool {
        softphoneService.registrationStatus.isRegistered
            && softphoneService.isNetworkAvailable
            && isValidNumber
    }

    // Valid numbers contain at least one digit and only digits, +, *, #.
    private var isValidNumber: Bool {
        guard !dialString.isEmpty else { return false }
        let allowed = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "+*#"))
        let hasOnlyAllowedChars = dialString.unicodeScalars.allSatisfy { allowed.contains($0) }
        let hasDigit = dialString.unicodeScalars.contains { CharacterSet.decimalDigits.contains($0) }
        return hasOnlyAllowedChars && hasDigit
    }
}
