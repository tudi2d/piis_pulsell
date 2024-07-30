//
//  WebSocketManager.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 30.07.24.
//

import Foundation

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var audioData: Data?

    init() {
        connect()
    }

    func connect() {
        let url = URL(string: "ws://10.181.216.240:9610")!
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    DispatchQueue.main.async {
                        self?.audioData = data
                    }
                    self?.receiveMessage()
                case .string(let text):
                    print("Received text: \(text)")
                    self?.receiveMessage()
                @unknown default:
                    fatalError()
                }
            case .failure(let error):
                print("Error in receiving message: \(error)")
                self?.reconnect()
            }
        }
    }

    func reconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        connect()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
