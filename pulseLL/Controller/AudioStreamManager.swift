//
//  AudioStream.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import Foundation
import AVFoundation
import Combine
import os

class AudioStreamManager: ObservableObject {
    @Published var isPlaying: Bool = false
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var cancellables = Set<AnyCancellable>()    
    private let logger = Logger()

    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            Logger.shared.log("Audio Stream Mnager is set up!")
        } catch {
            print("Failed to set audio session category. Error: \(error)")
        }
    }
    
    func startStream(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.play()
        self.isPlaying = true
        
        // Observe when the player item has finished playing
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .sink { [weak self] _ in
                self?.isPlaying = false
            }
            .store(in: &cancellables)
    }
    
    func stopStream() {
        player?.pause()
        isPlaying = false
    }
    
    func muteStream() {
        player?.volume = 0.0
    }
    func unmuteStream() {
        player?.volume = 1.0
    }
    
    private func observePlayerItem(_ playerItem: AVPlayerItem) {
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .sink { [weak self] _ in
                self?.isPlaying = false
                self?.logger.log("Playback finished.")
            }
            .store(in: &cancellables)

        playerItem.publisher(for: \.status)
            .sink { [weak self] status in
                switch status {
                case .unknown:
                    self?.logger.log("PlayerItem status: unknown.")
                case .readyToPlay:
                    self?.logger.log("PlayerItem status: ready to play.")
                case .failed:
                    self?.logger.error("PlayerItem status: failed. Error: \(String(describing: playerItem.error?.localizedDescription))")
                @unknown default:
                    self?.logger.error("PlayerItem status: unknown future case.")
                }
            }
            .store(in: &cancellables)
    }

    private func observePlayer(_ player: AVPlayer) {
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .waitingToPlayAtSpecifiedRate:
                    self?.logger.log("Player is waiting to play at specified rate.")
                case .playing:
                    self?.logger.log("Player is playing.")
                case .paused:
                    self?.logger.log("Player is paused.")
                @unknown default:
                    self?.logger.error("Player time control status: unknown future case.")
                }
            }
            .store(in: &cancellables)

        player.publisher(for: \.reasonForWaitingToPlay)
            .sink { [weak self] reason in
                if let reason = reason {
                    self?.logger.log("Player reason for waiting to play: \(reason.rawValue)")
                }
            }
            .store(in: &cancellables)
    }
}
