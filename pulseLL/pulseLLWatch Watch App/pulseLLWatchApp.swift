//
//  pulseLLWatchApp.swift
//  pulseLLWatch Watch App
//
//  Created by Tristan Häuser on 10.06.24.
//

import SwiftUI

@main
struct pulseLLWatch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private let workoutManager = WorkoutManager.shared
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ControlView()
                .environmentObject(workoutManager)
        }
    }
}
