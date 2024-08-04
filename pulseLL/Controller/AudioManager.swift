//
//  AudioPlayer.swift
//  pulseLL
//
//  Created by Tristan Häuser on 03.08.24.
//

import Foundation
import SwiftUI
import os
import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject {
    static let shared = AudioManager()
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private var canellable: AnyCancellable?
    
    
    public override init() {}
    
    deinit {
        canellable?.cancel()
    }
    
    private func activateSession() {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ {}
        
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {}
        
        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {}
    }
    
    func startAudio(fileName: String, fileExtension: String = "mp3") {
        print("Trying to start session")
        activateSession()
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Failed to find the audio file in the bundle.")
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        // Handling the completion of playback
        canellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime, object: playerItem)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.player?.seek(to: .zero) { success in
                    if success {
                        self.player?.play() // Replay from start
                    }
                }
            }
        
        player?.play()
    }

    
    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    func play() {
        if let player = player {
            player.play()
        }
    }
    
    func pause() {
        if let player = player {
            player.pause()
        }
    }
    
    func muteStream() {
        if let player = player {
            player.volume = 0.0
            Logger.shared.log("Audio Stream is muted!")
        }
    }
    func unmuteStream() {
        if let player = player {
            player.volume = 1.0
            Logger.shared.log("Audio Stream is unmuted!")
        }
    }

    
    func getPlaybackDuration() -> Double {
        guard let player = player else {
            return 0
        }
        
        return player.currentItem?.duration.seconds ?? 0
    }
    
}

