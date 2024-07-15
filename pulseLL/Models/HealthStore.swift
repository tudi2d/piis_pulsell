//
//  HealthStore.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import Foundation
import HealthKit

class HealthStore: ObservableObject {
    let healthStore = HKHealthStore()
    
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
    }
    
    func requestAuthorization() {
        // The quantity type to write to the health store.
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device")
            return
        }
        
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]


        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]


        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
                if success {
                    print("HealthKit authorization granted")
                    // Proceed with using HealthKit
                } else {
                    print("HealthKit authorization denied")
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
    }
}
