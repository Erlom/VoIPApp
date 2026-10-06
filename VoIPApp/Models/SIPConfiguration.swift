//
//  SIPConfiguration.swift
//  VoIPApp
//

import Foundation

/// SIP account credentials and server address used for registration and outbound calls.
struct SIPConfiguration {
    /// SIP username.
    let username: String

    /// SIP account password.
    let password: String

    /// Hostname or IP of the SIP proxy/PBX.
    let server: String
}
