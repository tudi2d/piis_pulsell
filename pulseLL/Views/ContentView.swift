//
//  ContentView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 10.06.24.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var didStartWorkout = false
    @State private var triggerAuthorization = false
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    Text("Welcome back, Tristan")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.trailing)
                }
                NavigationLink{
                    OnboardingView()
                } label: {
                    HStack {
                        Text("Workout your next song!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.7))
                    .cornerRadius(20)
                    .padding()
                    .foregroundColor(.white)
                }
                
                RecapList()
            }
            .padding()
        }
        .onAppear{
            triggerAuthorization.toggle()
            workoutManager.retrieveRemoteSession()
        }
    }
}

#Preview {
    ContentView()
}
