//
//  NetworkModel.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import Foundation

class NetworkManager: ObservableObject{
    private let baseURL = "http://192.168.0.146:5000"
    @Published var audioData: String?
    @Published var rawData: Data?
    
    static let shared = NetworkManager()
    
    func postVitalParameters(heartRate: Int, unixTimestamp: Int, songGenre: String, userID: String, activityType: String, regenerate: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        print("Sending new Message to Server with:")
        print("HeartRate: " + String(heartRate))
        print( "UnixTimestamp: " + String(unixTimestamp))
        print( "SongGenre: " + songGenre)
        print( "UserID: " + userID)
        print( "ActivityType: " + activityType)
        print( "Regenerate: " + String(regenerate))
        print("Current Song: " + (audioData ?? "No Song"))
        
        guard let url = URL(string: "\(baseURL)/vital_parameters") else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = VitalParameters(heart_rate: heartRate, unix_timestamp: unixTimestamp, song_genre: songGenre, user_id: userID, workout_id: 12345,activity_type: activityType, regenerate: regenerate)
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
            guard let httpResponse = response as? HTTPURLResponse,
                  let contentType = httpResponse.allHeaderFields["Content-Type"] as? String else {
                print("Invalid response or content type missing")
                return
            }
           /*
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "InvalidData", code: -1, userInfo: nil)))
                return
            }**/
            
            if contentType.contains("application/json") {
                self.rawData = data
                // Parse JSON from the data
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if let fullName = json["fullname"] as? String {
                            // Assuming audioData can store String, not just Data
                            DispatchQueue.main.async { [weak self] in
                                self!.objectWillChange.send()
                                self!.audioData = fullName
                                print("Full name extracted and stored: \(fullName)")
                            }
                        } else {
                            print("Full name key is not present in the JSON.")
                        }
                    }
                } catch {
                    print("Failed to parse JSON: \(error)")
                }
            }
            
            //completion(.success(responseString))
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
    func fetchAudio() -> Void {
        guard let url = URL(string: "\(baseURL)/Insert Route") else {
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
    func saveMP3FromData(_ data: Data, withName filename: String) {
        let fileManager = FileManager.default
        do {
            // Getting the document directory path
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsURL.appendingPathComponent("\(filename).mp3")
            
            // Writing the data to the file
            try data.write(to: fileURL, options: .atomic)
            print("Saved MP3 file at: \(fileURL.path)")
        } catch {
            print("Error saving MP3 file: \(error)")
        }
    }
}
