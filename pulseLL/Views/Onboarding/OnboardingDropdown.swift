//
//  OnboardingDropdown.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI


import SwiftUI

struct OnboardingDropdown: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var label: String
    @Binding var selectedOption: String
    var options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.headline)
                .foregroundColor(.gray)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption)
                        .font(.largeTitle)
                        .padding()
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .padding()
                }
                .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct OnboardingDropdownPreviewWrapper: View {
    @State private var selectedWorkout = "Running"
    
    var body: some View {
        OnboardingDropdown(label: "Workout", selectedOption: $selectedWorkout, options: ["Running", "Cycling", "Swimming"])
    }
}

#Preview {
    OnboardingDropdownPreviewWrapper()
}
