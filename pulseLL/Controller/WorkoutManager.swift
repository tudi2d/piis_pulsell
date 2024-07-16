//
//  HealthStore.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import Foundation
import HealthKit

class WorkoutManager: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var heartRate: Int = 0
    
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
