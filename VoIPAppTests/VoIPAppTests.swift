//
//  VoIPAppTests.swift
//  VoIPAppTests
//

import Testing
@testable import VoIPApp

// MARK: - Mock

final class MockDialerService: DialerServiceProtocol {
    var registrationStatus: RegistrationStatus = .unregistered
    var isNetworkAvailable: Bool = true
    private(set) var lastCalledNumber: String?

    func call(number: String) {
        lastCalledNumber = number
    }
}

// MARK: - DialerViewModel Tests

@Suite struct DialerViewModelTests {

    @Test func emptyDialStringIsInvalid() {
        let vm = DialerViewModel(service: MockDialerService())
        #expect(!vm.isValidNumber)
    }

    @Test func digitsOnlyIsValid() {
        let vm = DialerViewModel(service: MockDialerService())
        "5000".forEach { vm.append(String($0)) }
        #expect(vm.isValidNumber)
    }

    @Test func plusPrefixedNumberIsValid() {
        let vm = DialerViewModel(service: MockDialerService())
        vm.appendPlus()
        "420999999196".forEach { vm.append(String($0)) }
        #expect(vm.isValidNumber)
    }

    @Test func plusAloneIsInvalid() {
        let vm = DialerViewModel(service: MockDialerService())
        vm.appendPlus()
        #expect(!vm.isValidNumber)
    }

    @Test func specialCharsWithoutDigitIsInvalid() {
        let vm = DialerViewModel(service: MockDialerService())
        vm.append("*")
        vm.append("#")
        #expect(!vm.isValidNumber)
    }

    @Test func deleteLastRemovesOneCharacter() {
        let vm = DialerViewModel(service: MockDialerService())
        "123".forEach { vm.append(String($0)) }
        vm.deleteLast()
        #expect(vm.dialString == "12")
    }

    @Test func deleteLastOnEmptyDoesNothing() {
        let vm = DialerViewModel(service: MockDialerService())
        vm.deleteLast()
        #expect(vm.dialString.isEmpty)
    }

    @Test func canCallRequiresRegistrationNetworkAndValidNumber() {
        let service = MockDialerService()
        service.registrationStatus = .registered
        service.isNetworkAvailable = true
        let vm = DialerViewModel(service: service)
        "9196".forEach { vm.append(String($0)) }
        #expect(vm.canCall)
    }

    @Test func canCallFalseWhenNotRegistered() {
        let service = MockDialerService()
        service.registrationStatus = .unregistered
        service.isNetworkAvailable = true
        let vm = DialerViewModel(service: service)
        "9196".forEach { vm.append(String($0)) }
        #expect(!vm.canCall)
    }

    @Test func canCallFalseWhenNoNetwork() {
        let service = MockDialerService()
        service.registrationStatus = .registered
        service.isNetworkAvailable = false
        let vm = DialerViewModel(service: service)
        "9196".forEach { vm.append(String($0)) }
        #expect(!vm.canCall)
    }

    @Test func placeCallInvokesService() {
        let service = MockDialerService()
        service.registrationStatus = .registered
        service.isNetworkAvailable = true
        let vm = DialerViewModel(service: service)
        "9196".forEach { vm.append(String($0)) }
        vm.placeCall()
        #expect(service.lastCalledNumber == "9196")
    }

    @Test func placeCallDoesNothingWhenCannotCall() {
        let service = MockDialerService()
        service.registrationStatus = .unregistered
        let vm = DialerViewModel(service: service)
        "9196".forEach { vm.append(String($0)) }
        vm.placeCall()
        #expect(service.lastCalledNumber == nil)
    }
}
