//
//  AudioStream.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 29.07.24.
//

import Foundation
import AVFoundation
import Combine

class AudioStreamManager: ObservableObject {
    @Published var isPlaying: Bool = false
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var cancellables = Set<AnyCancellable>()

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
}
