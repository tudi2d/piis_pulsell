//
//  HealthStore.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import Foundation
import os
import HealthKit

@MainActor
class WorkoutManager: NSObject, ObservableObject {
    struct SessionStateChange {
        let newState: HKWorkoutSessionState
        let date: Date
    }
    
    @Published var sessionState: HKWorkoutSessionState = .notStarted
    @Published var heartRate: Double = 62
    @Published var elapsedTimeInterval: TimeInterval = 0
    @Published var workout: HKWorkout?
    @Published var workoutType: HKWorkoutActivityType = .running
    @Published var songGenre: String = "Techno"
    @Published var distance: Double = 0
    @Published var regenerate: Bool = false
    //More health data can be added later here(Must be added to Share/Read and WorkoutManager Extension)
    
    let typesToShare: Set = [HKQuantityType.workoutType()]
    let typesToRead: Set = [
        HKQuantityType(.heartRate),
        HKQuantityType.workoutType(),
        HKQuantityType(.distanceWalkingRunning)
    ]
    
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    
    #if os(watchOS)
    var builder: HKLiveWorkoutBuilder?
    #else
    var contextDate: Date?
    #endif
    
    let asynStreamTuple = AsyncStream.makeStream(of: SessionStateChange.self, bufferingPolicy: .bufferingNewest(1))
    
    static let shared = WorkoutManager()
    
    private override init() {
        super.init()
        Task {
            for await value in asynStreamTuple.stream {
                await consumeSessionStateChange(value)
            }
        }
    }
    
    private func consumeSessionStateChange(_ change: SessionStateChange) async {
        sessionState = change.newState
        #if os(watchOS)
        let elapsedTimeInterval = session?.associatedWorkoutBuilder().elapsedTime(at: change.date) ?? 0
        let elapsedTime = WorkoutElapsedTime(timeInterval: elapsedTimeInterval, date: change.date)
        if let elapsedTimeData = try? JSONEncoder().encode(elapsedTime) {
            await sendData(elapsedTimeData)
        }

        guard change.newState == .stopped, let builder else {
            return
        }

        let finishedWorkout: HKWorkout?
        do {
            try await builder.endCollection(at: change.date)
            finishedWorkout = try await builder.finishWorkout()
            session?.end()
        } catch {
            Logger.shared.log("Failed to end workout: \(error))")
            return
        }
        workout = finishedWorkout
        #endif
    }

    func startLocalWorkout() {
        Logger.shared.log("Trying to start local workout")
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
        Logger.shared.log("Debugging Workout started")
        
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
            self.heartRate = Double(heartRateValue)
        }
    }
}

extension WorkoutManager {
    func resetWorkout() {
        #if os(watchOS)
        builder = nil
        #endif
        workout = nil
        session = nil
        heartRate = 61
        distance = 0
        sessionState = .notStarted
        //songGenre = "ResetGenre"
    }
    
    func sendData(_ data: Data) async {
        do {
            try await session?.sendToRemoteWorkoutSession(data: data)
        } catch {
            Logger.shared.log("Failed to send data: \(error)")
        }
    }
}

extension WorkoutManager {
    func updateForStatistics(_ statistics: HKStatistics) {
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
            heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
        case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKQuantityType.quantityType(forIdentifier: .distanceCycling):
            let meterUnit = HKUnit.meter()
            distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            
        //More health data can be added later here
            
        default:
            return
        }
    }
}

extension WorkoutManager: HKWorkoutSessionDelegate {
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didChangeTo toState: HKWorkoutSessionState,
                                    from fromState: HKWorkoutSessionState,
                                    date: Date) {
        Logger.shared.log("Session state changed from \(fromState.rawValue) to \(toState.rawValue)")
        
        let sessionStateChange = SessionStateChange(newState: toState, date: date)
        asynStreamTuple.continuation.yield(sessionStateChange)
    }
        
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didFailWithError error: Error) {
        Logger.shared.log("\(#function): \(error)")
    }
    
   
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didDisconnectFromRemoteDeviceWithError error: Error?) {
        Logger.shared.log("\(#function): \(error)")
    }
  
    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession,
                                    didReceiveDataFromRemoteWorkoutSession data: [Data]) {
        Logger.shared.log("\(#function): \(data.debugDescription)")
        Task { @MainActor in
            do {
                for anElement in data {
                    try handleReceivedData(anElement)
                }
            } catch {
                Logger.shared.log("Failed to handle received data: \(error))")
            }
        }
    }
}

struct WorkoutElapsedTime: Codable {
    var timeInterval: TimeInterval
    var date: Date
}

extension HKWorkoutSessionState {
    var isActive: Bool {
        self != .notStarted && self != .ended
    }
}
