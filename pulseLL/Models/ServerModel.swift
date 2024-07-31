//
//  ServerModel.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import SwiftUI

class VitalParametersViewModel: ObservableObject {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Published var responseMessage: String?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager = NetworkManager()
    

    func sendVitalParameters(heartRate: Int) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let songGenre = workoutManager.songGenre
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
