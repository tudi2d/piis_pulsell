//
//  ServerModel.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import SwiftUI

class VitalParametersViewModel: ObservableObject {
    @Published var responseMessage: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager()
    let workoutManager = WorkoutManager.shared
    
    
    func sendVitalParameters(heartRate: Int, songGenre: String) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let userID = UserIDManager.shared.getUserID()
        isLoading = true
        networkManager.postVitalParameters(heartRate: heartRate, unixTimestamp: timestamp, songGenre: songGenre, userID: userID) { [weak self] result in
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
