//
//  NetworkModel.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import Foundation

class NetworkManager {
    private let baseURL = "http://10.181.216.240:5000"

    func postVitalParameters(heartRate: Int, unixTimestamp: Int, songGenre: String, userID: String, activityType: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("LOG")
        guard let url = URL(string: "\(baseURL)/vital_parameters") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = VitalParameters(heart_rate: heartRate, unix_timestamp: unixTimestamp, song_genre: songGenre, user_id: userID, workout_id: 12345,activity_type: activityType)
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
    
    func stopWorkout() -> Void {
        print("LOG")
        guard let url = URL(string: "\(baseURL)/stop_workout") else {
            print("ERROR")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                print(NSError(domain: "InvalidData", code: -1, userInfo: nil))
                return
            }
        }
        task.resume()
    }
}
