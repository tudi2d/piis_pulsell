//
//  iPhoneConnector.swift
//  pulseLLWatch Watch App
//
//  Created by Tristan Häuser on 10.06.24.
//
// Sets up connection between AppleWatch -> iPhone

import Foundation
import WatchConnectivity

class iPhoneConnector: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?){
    }
    
}
