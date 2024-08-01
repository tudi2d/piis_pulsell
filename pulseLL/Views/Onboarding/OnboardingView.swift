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
                    OnboardingDropdown(label: "Workout", selectedOption: $selectedWorkout, options: ["Running", "Cycling", "Swimming"])
                        .onChange(of: selectedGenre) { oldWorkout, newWorkout in
                                            workoutManager.songGenre = newWorkout
                                        }
                    OnboardingDropdown(label: "Genre", selectedOption: $selectedGenre, options: ["Techno", "Rock", "EDM", "House"])
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
                .background(.white.opacity(0.8))
                
                OnboardingMap().zIndex(-1)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
