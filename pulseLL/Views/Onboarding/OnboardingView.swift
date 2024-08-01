//
//  OnboardingView.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var path = NavigationPath()
    @State private var selectedWorkout = "Running"
    @State private var selectedGenre = "Techno"
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack {
                    OnboardingDropdown(label: "Workout", selectedOption: $selectedWorkout, options: ["Running", "Cycling", "Hiking"])
                        .onChange(of: selectedWorkout) {
                            switch selectedWorkout {
                            case "Running":
                                workoutManager.workoutType = .running
                            case "Cycling":
                                workoutManager.workoutType = .cycling
                            case "Hiking":
                                workoutManager.workoutType = .hiking
                            default:
                                workoutManager.workoutType = .running
                            }
                        }
                    
                    OnboardingDropdown(label: "Genre", selectedOption: $selectedGenre, options: ["Techno", "Rock", "Dubstep"])
                        .onChange(of: selectedGenre) { oldGenre, newGenre in
                            workoutManager.songGenre = newGenre
                        }
                    
                    Spacer()
                    
                    NavigationLink{WorkoutView()}label: {
                        Image(systemName: "record.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.trailing)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 50)
                }
                .padding(.top, 50)
                .background(.white.opacity(0.7))
                
                OnboardingMap().zIndex(-1)
            }
            .padding(.top, 50)
            .onAppear(){
                workoutManager.songGenre = "Techno"
                workoutManager.workoutType = .running
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(WorkoutManager.shared)
    }
}
