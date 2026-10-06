//
//  RegistrationStatus.swift
//  VoIPApp
//

import Foundation

/// Represents the SIP registration state, abstracting the SDK's internal RegistratorStateType.
enum RegistrationStatus: Equatable {
    case unregistered
    case registering
    case registered
    case failed(String)

    /// Human-readable label shown in the UI.
    var label: String {
        switch self {
        case .unregistered:       return "Unregistered"
        case .registering:        return "Registering…"
        case .registered:         return "Registered"
        case .failed(let reason): return "Failed: \(reason)"
        }
    }

    var isRegistered: Bool {
        if case .registered = self { return true }
        return false
    }
}
