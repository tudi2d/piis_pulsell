//
//  WorkoutControl.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI

struct WorkoutControl: View {
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
            Button(action: {
                // Pause action
            }) {
                Image(systemName: "pause.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
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
