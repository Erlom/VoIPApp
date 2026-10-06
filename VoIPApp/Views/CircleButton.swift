//
//  CircleButton.swift
//  VoIPApp
//

import SwiftUI

struct CircleButton<Content: View>: View {

    let color: Color
    var size: CGFloat = 80
    let action: () -> Void
    var longPressAction: (() -> Void)? = nil
    @ViewBuilder let content: () -> Content

    @State private var longPressConsumed = false

    var body: some View {
        Button {
            if longPressConsumed {
                longPressConsumed = false
            } else {
                action()
            }
        } label: {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .overlay { content() }
        }
        .buttonStyle(CircleButtonStyle(suppressScale: longPressConsumed))
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    longPressConsumed = true
                    longPressAction?()
                }
        )
    }
}

struct CircleIconButton: View {

    let color: Color
    var size: CGFloat = 80
    let systemImage: String
    let action: () -> Void

    var body: some View {
        CircleButton(color: color, size: size, action: action) {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundStyle(.white)
        }
    }
}

private struct CircleButtonStyle: ButtonStyle {
    var suppressScale: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let scaled = configuration.isPressed && !suppressScale
        return configuration.label
            .scaleEffect(scaled ? 0.92 : 1.0)
            .animation(.easeOut(duration: 0.08), value: scaled)
    }
}
