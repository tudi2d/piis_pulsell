//
//  pulseLLApp.swift
//  pulseLL
//
//  Created by Tristan Häuser on 10.06.24.
//

import SwiftUI

@main
struct pulseLLApp: App {
    private let workoutManager = WorkoutManager.shared
    private let networkManager = NetworkManager.shared
    
    var body: some Scene {
        WindowGroup {
            if UIDevice.current.userInterfaceIdiom == .phone {
                HomeView()
                    .environmentObject(workoutManager)
                    .environmentObject(networkManager)
            } else {
                HomeView()
            }
        }
    }
}
