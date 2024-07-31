//
//  WorkoutView.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import os
import SwiftUI


struct WorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject private var serverModel = VitalParametersViewModel()
    @StateObject var bleSdkManager = PolarBleSdkManager()
    @State private var didStartWorkout = false
    
    var body: some View {
        ZStack{
            VStack {
                let fromDate = workoutManager.session?.startDate ?? Date()
                let schedule = MetricsTimelineSchedule(from: fromDate, isPaused: workoutManager.sessionState == .paused)
                TimelineView(schedule) { context in
                    VStack {
                        WorkoutStats(bpm: Int(workoutManager.heartRate), genre: "Techno", time: headerView(context: context), distance: "6.2")
                        WorkoutMap()
                        WorkoutControl()
                            .frame(maxWidth: .infinity, maxHeight: 100)
                            .padding(.bottom)
                    }
                    .zIndex(1.0)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
            .onAppear{
                //workoutManager.startWorkout()
                if !workoutManager.sessionState.isActive {
                    startRunningOnWatch()
                }
                didStartWorkout = true
            }
            .onChange(of: workoutManager.heartRate, {
                serverModel.sendVitalParameters(heartRate: Int(workoutManager.heartRate))
            })
        }
    }
    private func startRunningOnWatch() {
        Task {
            do {
                try await workoutManager.startWatchWorkout(workoutType: .running)
            } catch {
                Logger.shared.log("Failed to start running on the paired watch.")
            }
        }
    }
}
    
extension WorkoutView {
    @ViewBuilder
    private func headerView(context: TimelineViewDefaultContext) -> some View {
        VStack {
            ElapsedTimeView(elapsedTime: workoutTimeInterval(context.date), showSubseconds: context.cadence == .live)
                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                .foregroundColor(.black)
                .background(Color.white)
                .font(.system(.title, design: .rounded).monospacedDigit().lowercaseSmallCaps())
        }
    }
    
    private func workoutTimeInterval(_ contextDate: Date) -> TimeInterval {
        var timeInterval = workoutManager.elapsedTimeInterval
        if workoutManager.sessionState == .running {
            if let referenceContextDate = workoutManager.contextDate {
                timeInterval += (contextDate.timeIntervalSinceReferenceDate - referenceContextDate.timeIntervalSinceReferenceDate)
            } else {
                workoutManager.contextDate = contextDate
            }
        } else {
            var date = contextDate
            date.addTimeInterval(workoutManager.elapsedTimeInterval)
            timeInterval = date.timeIntervalSinceReferenceDate - contextDate.timeIntervalSinceReferenceDate
            workoutManager.contextDate = nil
        }
        return timeInterval
    }
}

struct WorkoutView_Preview: PreviewProvider {
    static var previews: some View {
        let workoutManager = WorkoutManager.shared
        
        WorkoutView()
            .environmentObject(workoutManager)
    }
}
