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
    var imageNames: [String] {
            (1...40).map { "wave_\($0)" }
        }
    var randomImageName: String {
            imageNames.randomElement() ?? "wave_1"
        }
    var recap: Recap
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(height: 100)
                .cornerRadius(15)
            Image(randomImageName)
                .resizable()
                .frame(height: 50)
                .opacity(0.9)
            HStack{
                Spacer()
                Text(recap.genre)
                    .font(.body)
                    .fontWeight(.semibold)
                Spacer()
                Text(recap.time)
                    .font(.body)
                    .fontWeight(.semibold)
                Spacer()
                Text(String(recap.bpm) + "bpm")
                    .font(.body)
                    .fontWeight(.semibold)
                Spacer()
            }
            
        }
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardView( recap: recaps[0])
    }
}
