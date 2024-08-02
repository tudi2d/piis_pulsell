//
//  workoutCardView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 01.08.24.
//

import Foundation
import os
import SwiftUI

struct WorkoutCardView : View {
    var recap: Recap
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.gray.opacity(0.7))
                .frame(height: 100)
                .cornerRadius(15)
            Image("test")
                .resizable()
                .frame(height: 50)
                .opacity(0.9)
            HStack{
                Spacer()
                Text(recap.genre)
                    .font(.body)
                Spacer()
                Text(recap.time)
                    .font(.body)
                Spacer()
                Text(String(recap.bpm) + "bpm")
                    .font(.body)
                Spacer()
            }
            
        }
        .padding(.horizontal)
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardView( recap: recaps[0])
    }
}
