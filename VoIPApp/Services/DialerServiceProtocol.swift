//
//  DialerServiceProtocol.swift
//  VoIPApp
//

import Foundation

protocol DialerServiceProtocol: AnyObject {
    var registrationStatus: RegistrationStatus { get }
    var isNetworkAvailable: Bool { get }
    func call(number: String)
}

extension SoftphoneService: DialerServiceProtocol {}
