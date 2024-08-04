//
//  WorkoutControl.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI
import os
import AVFoundation

// http://10.181.216.240:5000

struct WorkoutControl: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var networkManager: NetworkManager
    @StateObject private var serverModel = VitalParametersViewModel()
    @StateObject private var audioStreamModel = AudioStreamManager()
    @StateObject var audioManager = AudioManager()
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
                    //audioStreamModel.startStream(from: URL(string: "https://172.20.10.2:9610/playlist.m3u8")!)
                    print("Regenerate")
                    serverModel.sendVitalParameters(heartRate: Int(workoutManager.heartRate), songGenre: workoutManager.songGenre, workoutType: workoutManager.workoutType, regenerate:true)
                    
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
                        audioManager.muteStream()
                        if(workoutManager.sessionState == .running){
                            Logger.shared.log("Pausing workout")
                            session?.pause()
                        }
                        isPaused = true
                    } else if (isPaused){
                        Logger.shared.log("Starting audio stream")
                        audioManager.unmuteStream()
                        if(workoutManager.sessionState == .paused){
                            Logger.shared.log("Resuming workout")
                            session?.resume()
                        }
                        isPaused = false
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
                    networkManager.stopWorkout();
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
            print("Audio triggered with# \(networkManager.audioData ?? "Error")")
            audioManager.startAudio(fileName: networkManager.audioData ?? "intro_ran1_120")
        }
        .onChange(of: networkManager.audioData, {
            audioManager.deactivateSession()
            audioManager.startAudio(fileName: networkManager.audioData ?? "dubstep_ran1_120")
            print("Replaced Audio")
        })
    }
}

struct WorkoutControl_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutControl()
            .environmentObject(WorkoutManager.shared)
    }
}
