//
//  WorkoutControl.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI

struct WorkoutControl: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject private var audioStreamModel = AudioStreamManager()
    @State private var returnToStartView = false
    
    
    var body: some View {
        NavigationStack{
            HStack {
                Spacer()
                Button(action: {
                    // Like action
                }) {
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Spacer(minLength: 40)
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
                Spacer(minLength: 40)
                Button {
                    if let session = workoutManager.session {
                        workoutManager.sessionState == .running ? session.pause() : session.resume()
                    }
                } label: {
                    let title = workoutManager.sessionState == .running ? "Pause" : "Resume"
                    let systemImage = workoutManager.sessionState == .running ? "pause" : "play"
                    ButtonLabel(title: title, systemImage: systemImage)
                }
                .frame(width: 50, height: 50)
                .disabled(!workoutManager.sessionState.isActive)
                Spacer(minLength: 40)
                Button {
                    workoutManager.session?.stopActivity(with: .now )
                    returnToStartView = true
                } label: {
                    ButtonLabel(title: "End", systemImage: "xmark")
                }
                .tint(.red)
                .frame(width: 50, height: 50)
                .disabled(!workoutManager.sessionState.isActive)
                .navigationDestination(isPresented: $returnToStartView) {
                    ContentView()
                }
                    
                    Spacer()
                }
                .buttonStyle(.bordered)
                .padding()
                .foregroundColor(.black)
            }
        }
    }
#Preview {
    WorkoutControl()
}
