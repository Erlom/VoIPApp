//
//  AppConfiguration.swift
//  VoIPApp
//

import Foundation

/// Top-level configuration bundling SIP credentials with the LibSoftphone SDK license key.
struct AppConfiguration {
    /// SIP account used for registration and outbound calls.
    let sip: SIPConfiguration

    /// LibSoftphone SDK license key tied to the app's bundle identifier.
    let licenseKey: String
}
