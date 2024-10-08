//
//  AppDelegate.swift
//  pulseLL
//
//  Created by Tristan Häuser on 29.07.24.
//

import os
import WatchKit
import HealthKit
import SwiftUI

class AppDelegate: NSObject, WKApplicationDelegate {

    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        Task {
            do {
                WorkoutManager.shared.resetWorkout()
                try await WorkoutManager.shared.startWorkout(workoutConfiguration: workoutConfiguration)
                Logger.shared.log("Successfully started workout")
            } catch {
                Logger.shared.log("Failed started workout")
            }
        }
    }
}
