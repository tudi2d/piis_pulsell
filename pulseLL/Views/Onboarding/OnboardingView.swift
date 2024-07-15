//
//  OnboardingView.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var selectedWorkout = "Running"
    @State private var selectedGenre = "Techno"
    
    var body: some View {
        VStack {
            // Dropdowns
            OnboardingDropdown(label: "Workout", selectedOption: $selectedWorkout, options: ["Running", "Cycling", "Swimming"])
            OnboardingDropdown(label: "Genre", selectedOption: $selectedGenre, options: ["Techno", "Rock", "EDM", "House"])
            
            Spacer()
            
            Button(action: {
            }) {
                Image(systemName: "stop.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(.trailing)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 50)
        }
        .padding(.top, 50)
    }
}

#Preview {
    OnboardingView()
}
