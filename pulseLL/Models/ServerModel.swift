//
//  ServerModel.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import SwiftUI
import HealthKit

class VitalParametersViewModel: ObservableObject {
    @Published var responseMessage: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager.shared
    let workoutManager = WorkoutManager.shared
    
    
    func sendVitalParameters(heartRate: Int, songGenre: String, workoutType: HKWorkoutActivityType, regenerate: Bool){
        let timestamp = Int(Date().timeIntervalSince1970)
        let userID = UserIDManager.shared.getUserID()
        
        var activityType: String {
            switch workoutType{
            case HKWorkoutActivityType.running: return "running"
            case HKWorkoutActivityType.swimming: return "swimming"
            case HKWorkoutActivityType.hiking: return "hiking"
            default:
                return "lol broken"
            }
        }
        
        isLoading = true
        networkManager.postVitalParameters(heartRate: heartRate, unixTimestamp: timestamp, songGenre: songGenre, userID: userID, activityType: activityType, regenerate: regenerate) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let message):
                    self?.responseMessage = message
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.responseMessage = nil
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
