//
//  AudioStreamDecoder.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 30.07.24.
//

import Foundation
import AVFoundation

class AudioStreamReceiver: NSObject {
    private var inputStream: InputStream?
    private let bufferSize = 1024
    private var audioEngine: AVAudioEngine!
    private var audioPlayerNode: AVAudioPlayerNode!
    private var audioFormat: AVAudioFormat!

    func startReceivingAudioStream(url: URL) {
        // Setup audio engine and player node
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // Define the audio format (match the server stream format)
        let sampleRate = 44100.0
        let channels = 2
        audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: AVAudioChannelCount(channels), interleaved: true)
        
        // Connect the player node to the engine
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFormat)
        
        // Start the audio engine
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
            return
        }
        
        // Create a data task to receive audio stream
        let task = URLSession.shared.streamTask(withHostName: url.host!, port: url.port ?? 80)
        task.resume()
        
        // Start reading data
        receiveData(task: task)
    }

    private func receiveData(task: URLSessionStreamTask) {
        task.readData(ofMinLength: 0, maxLength: bufferSize, timeout: .infinity) { [weak self] data, eof, error in
            guard let self = self, let data = data, !data.isEmpty else {
                if let error = error {
                    print("Error receiving data: \(error.localizedDescription)")
                }
                return
            }
            
            self.processReceivedData(data)
            
            // Continue reading data
            self.receiveData(task: task)
        }
    }

    private func processReceivedData(_ data: Data) {
        // Create an audio buffer from the received data
        guard let audioFormat = audioFormat else { return }
        let frameCount = AVAudioFrameCount(data.count) / audioFormat.streamDescription.pointee.mBytesPerFrame
        guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCount) else { return }
        audioBuffer.frameLength = frameCount

        // Copy data to the audio buffer
        guard let bufferPointer = audioBuffer.audioBufferList.pointee.mBuffers.mData else {
            print("Error: mData is nil")
            return
        }
        data.copyBytes(to: bufferPointer.assumingMemoryBound(to: UInt8.self), count: data.count)
        
        // Schedule the buffer for playback
        audioPlayerNode.scheduleBuffer(audioBuffer, completionHandler: nil)
        
        // Start playing if not already playing
        if !audioPlayerNode.isPlaying {
            audioPlayerNode.play()
        }
    }


}
