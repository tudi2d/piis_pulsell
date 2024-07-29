//
//  ControlView.swift
//  pulseLLWatch Watch App
//
//  Created by Tristan Häuser on 29.07.24.
//

import os
import SwiftUI
import HealthKit

struct ControlView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack {
            Button {
                startWorkout()
            } label: {
                ButtonLabel(title: "Start", systemImage: "figure.outdoor.cycle")
            }
            .disabled(workoutManager.sessionState.isActive)
            .tint(.green)
            
            Button {
                workoutManager.sessionState == .running ? workoutManager.session?.pause() : workoutManager.session?.resume()
            } label: {
                let title = workoutManager.sessionState == .running ? "Pause" : "Resume"
                let systemImage = workoutManager.sessionState == .running ? "pause" : "play"
                ButtonLabel(title: title, systemImage: systemImage)
            }
            .disabled(!workoutManager.sessionState.isActive)
            .tint(.blue)
            
            Button {
                workoutManager.session?.stopActivity(with: .now)
            } label: {
                ButtonLabel(title: "End", systemImage: "xmark")
            }
            .tint(.red)
            .disabled(!workoutManager.sessionState.isActive)
        }
    }
    
    private func startWorkout() {
        Task {
            do {
                let configuration = HKWorkoutConfiguration()
                configuration.activityType = .cycling
                configuration.locationType = .outdoor
                try await workoutManager.startWorkout(workoutConfiguration: configuration)
            } catch {
                Logger.shared.log("Failed to start workout \(error))")
            }
        }
    }
}
