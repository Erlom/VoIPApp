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

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .overlay { content() }
        }
        .buttonStyle(CircleButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in longPressAction?() }
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
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
