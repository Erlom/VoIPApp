//
//  DialerViewModel.swift
//  VoIPApp
//

import Foundation

@Observable
final class DialerViewModel {

    private let service: any DialerServiceProtocol

    var dialString: String = ""

    init(service: any DialerServiceProtocol) {
        self.service = service
    }

    var registrationStatus: RegistrationStatus { service.registrationStatus }
    var isNetworkAvailable: Bool { service.isNetworkAvailable }

    var isValidNumber: Bool {
        guard !dialString.isEmpty else { return false }
        let allowed = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "+*#"))
        let onlyAllowed = dialString.unicodeScalars.allSatisfy { allowed.contains($0) }
        let hasDigit = dialString.unicodeScalars.contains { CharacterSet.decimalDigits.contains($0) }
        return onlyAllowed && hasDigit
    }

    var canCall: Bool {
        service.registrationStatus.isRegistered
            && service.isNetworkAvailable
            && isValidNumber
    }

    func append(_ key: String) {
        dialString.append(key)
    }

    func appendPlus() {
        dialString.append("+")
    }

    func deleteLast() {
        guard !dialString.isEmpty else { return }
        dialString.removeLast()
    }

    func placeCall() {
        guard canCall else { return }
        service.call(number: dialString)
    }
}
