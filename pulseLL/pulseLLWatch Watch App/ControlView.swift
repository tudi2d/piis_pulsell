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
    @State private var workoutIcon = "figure.run"
    var body: some View {
        VStack {
            
            Button {
                startWorkout()
                switch workoutManager.workoutType {
                case .running:
                    workoutIcon = "figure.run"
                case .cycling:
                    workoutIcon = "figure.outdoor.cycle"
                case .hiking:
                    workoutIcon =  "figure.hiking"
                default:
                    workoutIcon = "figure.run"
                }
            } label: {
                let systemImage = workoutManager.workoutType == .running ? "figure.run" : "figure.outdoor.cycle"
                ButtonLabel(title: "Start", systemImage: systemImage)
                            
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
        .onAppear {
            workoutManager.requestAuthorization()
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
