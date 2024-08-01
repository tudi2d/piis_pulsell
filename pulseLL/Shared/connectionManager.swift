//
//  connectionManager.swift
//  pulseLL
//
//  Created by Tristan Häuser on 31.07.24.
//

import Foundation
import WatchConnectivity

class connectionManager: NSObject, ObservableObject {
    static let shared = connectionManager()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private override init() {
        super.init()
    }
    func detect() {
        session?.delegate = self
        session?.activate()
    }
}
extension connectionManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Check if the iPhone is paired with the Apple Watch
        if session.isPaired {
            print("Apple Watch is paired")
        } else {
            print("Apple Watch is not paired")
        }
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
}
