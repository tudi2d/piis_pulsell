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
            HStack(spacing: 20) {
                Spacer()
                Button(action: {
                    print("Regenerate")
                }) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Spacer()
                Button (action:{
                    if let session = workoutManager.session {
                        if(workoutManager.sessionState == .running){
                            audioStreamModel.stopStream()
                            session.pause()
                        }else{
                            session.resume()
                            if let url = URL(string: "https://dispatcher.rndfnk.com/br/brklassik/live/mp3/high") {
                                audioStreamModel.startStream(from: url)
                            }
                        }
                    }
                }) {
                    let systemName = workoutManager.sessionState == .running ? "pause.circle.fill" : "play.circle.fill"
                    Image(systemName: systemName)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .disabled(!workoutManager.sessionState.isActive)
                Spacer()
                Button (action: {
                    workoutManager.session?.stopActivity(with: .now )
                    returnToStartView = true
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .tint(.red)
                .disabled(!workoutManager.sessionState.isActive)
                .navigationDestination(isPresented: $returnToStartView) {
                    ContentView()
                }
                Spacer()
            }
            .foregroundColor(.black)
        }
    }
}


struct WorkoutControl_Preview: PreviewProvider {
    static var previews: some View {
        // Create an instance of WorkoutManager
        let workoutManager = WorkoutManager.shared
        
        // Inject the environment object into the view
        WorkoutControl()
            .environmentObject(workoutManager)
    }
}
