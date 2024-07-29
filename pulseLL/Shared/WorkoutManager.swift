//
//  HealthStore.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import Foundation
import os
import HealthKit

class WorkoutManager: NSObject, ObservableObject {
    struct SessionStateChange {
        let newState: HKWorkoutSessionState
        let date: Date
    }
    
    @Published var sessionState: HKWorkoutSessionState = .notStarted
    @Published var heartRate: Int = 0
    @Published var workout: HKWorkout?
    
    let typesToShare: Set = [HKQuantityType.workoutType()]
    let typesToRead: Set = [HKQuantityType.quantityType(forIdentifier: .heartRate)]
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    
    #if os(watchOS)
    var builder: HKLiveWorkoutBuilder?
    #else
    var contextDate: Date?
    #endif
    
    let asynStreamTuple = AsyncStream.makeStream(of: SessionSateChange.self, bufferingPolicy: .bufferingNewest(1))
    
    static let shared = WorkoutManager()
    
    
    
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
        print("Workout started")
        
        let startDate = Date()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: nil, options: .strictStartDate)

        let query = HKAnchoredObjectQuery(
            type: HKObjectType.quantityType(forIdentifier: .heartRate)!,
            predicate: predicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { query, samples, deletedObjects, newAnchor, error in
            self.process(samples)
        }
        
        query.updateHandler = { [weak self] query, samples, deletedObjects, newAnchor, error in
            self?.process(samples)
        }
        
        healthStore.execute(query)
    }
    
    
    private func process(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {
            return
        }

        guard let lastSample = heartRateSamples.last else {
            // Current workaround until we have properly mocked the data
            print("CURRENT HR: ", 0)
            DispatchQueue.main.async {
                self.heartRate = 0
            }
            return
        }
        
        let unit = HKUnit(from: "count/min")
        let heartRateValue = Int(lastSample.quantity.doubleValue(for: unit))
        
        print("CURRENT HR: ", heartRateValue)
        DispatchQueue.main.async {
            self.heartRate = heartRateValue
        }
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
