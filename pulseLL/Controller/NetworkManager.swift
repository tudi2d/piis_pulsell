//
//  NetworkModel.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import Foundation

class NetworkManager {
    private let baseURL = "http://10.181.216.240:5000"

    func postVitalParameters(heartRate: Int, unixtimestamp: Int, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/vital_parameters") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = VitalParameters(heart_rate: heartRate, unix_timestamp: unixtimestamp)
        let encoder = JSONEncoder()

        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "InvalidData", code: -1, userInfo: nil)))
                return
            }
            completion(.success(responseString))
        }

        task.resume()
    }
}
