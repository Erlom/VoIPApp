//
//  SoftphoneService.swift
//  VoIPApp
//

import Foundation
import Softphone_Swift

@Observable
final class SoftphoneService: NSObject {

    // MARK: - Observable state

    private(set) var registrationStatus: RegistrationStatus = .unregistered
    private(set) var activeCallInfo: CallInfo?
    private(set) var isNetworkAvailable: Bool = true
    private(set) var initializationError: Error?

    // MARK: - Private

    private let config: AppConfiguration
    private var observerProxy: SoftphoneObserverProxyBridge?
    private var activeSDKCall: SoftphoneCallEvent?

    // MARK: - Init

    init(config: AppConfiguration) {
        self.config = config
        super.init()
        do {
            try initializeSDK()
        } catch {
            initializationError = error
        }
    }

    // MARK: - SDK setup

    private func initializeSDK() throws {
        let licenseXML = """
            <root>
                <saas>
                    <identifier>\(config.licenseKey)</identifier>
                </saas>
            </root>
            """
        try SoftphoneBridge.initialize(licenseXML, overrideDefaults: { prefs in
            prefs.overrideSipisDisabled(true)
            prefs.overrideDefaultPushNotificationsEnabled(false)
        })

        let proxy = SoftphoneObserverProxyBridge()
        proxy.delegate = self
        SoftphoneBridge.instance().setObserver(proxy)
        observerProxy = proxy

        configureAccount()
    }

    private func configureAccount() {
        let registration = SoftphoneBridge.instance().registration()
        let sip = config.sip

        if let _ = registration?.getAccount(accountId: "sip") {
            return
        }

        let xml = XmlTree(name: "account")
        xml.setAttribute(name: "id", value: "sip")
        xml.setNodeValue(value: "VoIP Account", name: "title")
        xml.setNodeValue(value: sip.username, name: "username")
        xml.setNodeValue(value: sip.password, name: "password")
        xml.setNodeValue(value: sip.server, name: "host")
        xml.setNodeValue(value: "udp", name: "transport")
        registration?.saveAccount(xml)
        registration?.updateAll()
    }
}

// MARK: - SoftphoneDelegateBridge

extension SoftphoneService: SoftphoneDelegateBridge {

    func onHoldStateChanged(states: CallHoldStates, call: SoftphoneCallEvent) {}

    func onMediaStatusChanged(media: CallMediaStatus, call: SoftphoneCallEvent) {}

    func onRegistrationStateChanged(state: RegistratorStateType, accountId: String) {
        DispatchQueue.main.async {
            switch state {
            case RegistratorState_Registered:   self.registrationStatus = .registered
            case RegistratorState_Registering:  self.registrationStatus = .registering
            case RegistratorState_Unauthorized: self.registrationStatus = .failed("Unauthorized")
            case RegistratorState_Error:        self.registrationStatus = .failed("Error")
            default:                            self.registrationStatus = .unregistered
            }
        }
    }

    func onCallStateChanged(state: CallStateType, call: SoftphoneCallEvent) {
        DispatchQueue.main.async {
            switch state {
            case CallState_Trying, CallState_Ringing:
                self.activeSDKCall = call
                self.activeCallInfo = CallInfo(
                    displayName: call.getRemoteUser(index: 0)?.displayName ?? "",
                    number: call.getRemoteUser(index: 0)?.genericUri ?? "",
                    connectedAt: nil,
                    callState: state == CallState_Ringing ? .ringing : .connecting
                )

            case CallState_Established:
                self.activeSDKCall = call
                if let info = self.activeCallInfo {
                    self.activeCallInfo = CallInfo(
                        displayName: info.displayName,
                        number: info.number,
                        connectedAt: Date(),
                        callState: .active
                    )
                }

            default:
                SoftphoneBridge.instance().calls()?.close(call)
                self.activeSDKCall = nil
                self.activeCallInfo = nil
            }
        }
    }

    func onNetworkChangeDetected(_ network: NetworkType) {
        DispatchQueue.main.async {
            self.isNetworkAvailable = (network != NetworkType_None)
        }
    }

    func onNewEvent(_ event: SoftphoneEvent) {}

    func onEventsChanged(events: SoftphoneChangedEvents, streams: SoftphoneChangedStreams) {}
}
