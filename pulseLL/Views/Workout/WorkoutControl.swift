//
//  WorkoutControl.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI

struct WorkoutControl: View {
    @StateObject private var audioStreamModel = AudioStreamManager()

    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                // Like action
            }) {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            Spacer()
            if audioStreamModel.isPlaying {
                Button(action: {
                    audioStreamModel.stopStream()
                }) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            } else {
                Button(action: {
                    // Replace with your audio stream URL
                    if let url = URL(string: "https://dispatcher.rndfnk.com/br/brklassik/live/mp3/high") {
                        audioStreamModel.startStream(from: url)
                    }
                }) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            Spacer()
            Button(action: {
                // Close action
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            Spacer()
        }
        .padding()
        .foregroundColor(.black)
    }
}
#Preview {
    WorkoutControl()
}
