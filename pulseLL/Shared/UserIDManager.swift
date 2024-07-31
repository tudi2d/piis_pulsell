//
//  UserIDManager.swift
//  pulseLL
//
//  Created by Tristan Häuser on 31.07.24.
//

import Foundation

class UserIDManager {
    static let shared = UserIDManager()
    
    private let userDefaultsKey = "uniqueUserID"
    
    private init() {
        if UserDefaults.standard.string(forKey: userDefaultsKey) == nil {
            let newUUID = UUID().uuidString
            UserDefaults.standard.set(newUUID, forKey: userDefaultsKey)
        }
    }
    
    func getUserID() -> String {
        return UserDefaults.standard.string(forKey: userDefaultsKey) ?? "Unknown"
    }
}

