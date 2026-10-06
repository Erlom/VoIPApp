//
//  CallInfo.swift
//  VoIPApp
//

import Foundation

/// Lifecycle state of an outgoing call.
enum CallState {
    case idle
    case connecting
    case ringing
    case active
    case held
    case ended
}

/// Snapshot of the active call shown on the Call screen.
struct CallInfo {
    /// Display name of the remote party (may be empty).
    let displayName: String

    /// Raw number / URI dialled by the user.
    let number: String

    /// Moment the call was answered (nil until the call becomes active).
    let connectedAt: Date?

    var callState: CallState

    /// Duration in whole seconds since the call was answered.
    var duration: TimeInterval {
        guard let start = connectedAt else { return 0 }
        return Date().timeIntervalSince(start)
    }
    
    var formattedNumber: String {
        formatPhoneNumber(number)
    }

    var formattedDisplayName: String {
        displayName.isEmpty ? formattedNumber : formatPhoneNumber(displayName)
    }

    private func formatPhoneNumber(_ raw: String) -> String {
        guard raw.hasPrefix("+") else { return raw }
        let digits = String(raw.dropFirst())
        let groups = stride(from: 0, to: digits.count, by: 3).map { offset -> String in
            let start = digits.index(digits.startIndex, offsetBy: offset)
            let end = digits.index(start, offsetBy: min(3, digits.count - offset))
            return String(digits[start..<end])
        }
        return "+" + groups.joined(separator: "\u{00A0}")
    }

}
