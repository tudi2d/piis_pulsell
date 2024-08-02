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
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            Logger.shared.log("Audio Stream Mnager is set up!")
            
        } catch {
            Logger.shared.error("Failed to set audio session category. Error: \(error)")
        }
    }
    
    func startStream(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        self.player?.play()
        self.isPlaying = true
        Logger.shared.log("Audio Stream is starting!")
        
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
        Logger.shared.log("Audio Stream is stopping!")
    }
    
    func muteStream() {
        player?.volume = 0.0
        Logger.shared.log("Audio Stream is muted!")
    }
    func unmuteStream() {
        player?.volume = 1.0
        Logger.shared.log("Audio Stream is unmuted!")
    }
}
