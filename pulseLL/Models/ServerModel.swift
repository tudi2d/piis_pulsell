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

    func sendVitalParameters(heartRate: Int) {
        isLoading = true
        networkManager.postVitalParameters(heartRate: heartRate) { [weak self] result in
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
