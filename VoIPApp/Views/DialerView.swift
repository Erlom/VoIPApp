//
//  DialerView.swift
//  VoIPApp
//

import SwiftUI

struct DialerView: View {

    @Environment(DialerViewModel.self) private var viewModel
    @Environment(AppSettings.self) private var settings

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
                StatusBadge(status: viewModel.registrationStatus)
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
        Text(viewModel.dialString.isEmpty ? "Enter number" : viewModel.dialString)
            .font(.system(size: 34, weight: .light, design: .monospaced))
            .foregroundStyle(viewModel.dialString.isEmpty ? .tertiary : .primary)
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
                            action: { viewModel.append(key) },
                            longPressAction: key == "0" ? { viewModel.appendPlus() } : nil
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
                color: viewModel.canCall ? .green : Color(.systemGray3),
                systemImage: "phone.fill",
                action: { viewModel.placeCall() }
            )
            .disabled(!viewModel.canCall)

            Button {
                viewModel.deleteLast()
            } label: {
                Image(systemName: "delete.backward")
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
            .opacity(viewModel.dialString.isEmpty ? 0.3 : 1)
            .disabled(viewModel.dialString.isEmpty)
            .frame(width: 80, height: 80)
        }
        .padding(.top, 8)
    }
}
