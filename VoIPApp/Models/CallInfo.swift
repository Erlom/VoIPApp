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
}
