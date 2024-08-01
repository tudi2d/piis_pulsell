//
//  WorkoutManagerWatchOS.swift
//  pulseLL
//
//  Created by Tristan Häuser on 29.07.24.
//


import Foundation
import os
import HealthKit

extension WorkoutManager {

    func requestAuthorization() {
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
            } catch {
                Logger.shared.log("Failed to request authorization: \(error)")
            }
        }
    }
    
    func startWorkout(workoutConfiguration: HKWorkoutConfiguration) async throws {
        session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
        builder = session?.associatedWorkoutBuilder()
        session?.delegate = self
        builder?.delegate = self
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)
    
        try await session?.startMirroringToCompanionDevice()
       
        let startDate = Date()
        session?.startActivity(with: startDate)
        try await builder?.beginCollection(at: startDate)
        Logger.shared.log("Starting Workout on Watch")
    }
    
    func handleReceivedData(_ data: Data) throws {
        guard let decodedQuantity = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQuantity.self, from: data) else {
            return
        }

        let sampleDate = Date()
        }
    }

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    nonisolated func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
      
        Task { @MainActor in
            var allStatistics: [HKStatistics] = []
            
            for type in collectedTypes {
                if let quantityType = type as? HKQuantityType, let statistics = workoutBuilder.statistics(for: quantityType) {
                    updateForStatistics(statistics)
                    allStatistics.append(statistics)
                }
            }
            
            let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: allStatistics, requiringSecureCoding: true)
            guard let archivedData = archivedData, !archivedData.isEmpty else {
                Logger.shared.log("Encoded cycling data is empty")
                return
            }
            
            await sendData(archivedData)
        }
    }
    
    nonisolated func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
}

