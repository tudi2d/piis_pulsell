//
//  WorkoutControl.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI
import os

// http://10.181.216.240:5000

struct WorkoutControl: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject private var audioStreamModel = AudioStreamManager()
    @State private var isPaused = false
    @State private var returnToStartView = false
    @State private var degreesTilted = 0.0
    
    
    var body: some View {
        NavigationStack{
            HStack(spacing: 20) {
                Spacer()
                Button(action: {
                    withAnimation(.bouncy(duration:0.5)) {
                        degreesTilted = degreesTilted + 360
                    }
                    print("Regenerate")
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(degreesTilted), anchor: .center)
                }
                Spacer()
                Button (action:{
                    let session = workoutManager.session
                    if (!isPaused) {
                        Logger.shared.log("Stopping audio stream")
                        audioStreamModel.stopStream()
                        if(workoutManager.sessionState == .running){
                            Logger.shared.log("Pausing workout")
                            session?.pause()
                            isPaused = true
                        }
                    } else if (isPaused){
                        if let url = URL(string: "http://10.181.216.240:9610/playlist.m3u8") {
                            Logger.shared.log("Starting audio stream")
                            audioStreamModel.startStream(from: url)
                        }
                        if(workoutManager.sessionState == .paused){
                            Logger.shared.log("Resuming workout")
                            session?.resume()
                            isPaused = false
                        }
                    }
                }) {
                    let systemName = isPaused == false ? "pause.circle.fill" : "play.circle.fill"
                    Image(systemName: systemName)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                //.disabled(!workoutManager.sessionState.isActive)
                Spacer()
                Button (action: {
                    print("Test?")
                    workoutManager.session?.stopActivity(with: .now )
                    returnToStartView = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .tint(.red)
                //.disabled(!workoutManager.sessionState.isActive)
                .navigationDestination(isPresented: $returnToStartView) {
                    HomeView()
                }
                Spacer()
            }
            .foregroundColor(.black)
        }
        .onAppear(){
            //audioStreamModel.startStream(from: URL(string: "https://dispatcher.rndfnk.com/br/brklassik/live/mp3/high")!)
        }
    }
}

struct WorkoutControl_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutControl()
            .environmentObject(WorkoutManager.shared)
    }
}
