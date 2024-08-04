//
//  workoutCardAudioView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 02.08.24.
//

import Foundation
import os
import SwiftUI

struct WorkoutCardAudioView : View {
    var recap: Recap
    var audioManager = AudioManager()
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(height: 100)
                .cornerRadius(15)
            Image("test")
                .resizable()
                .frame(height: 50)
                .opacity(0.9)
            HStack{
                Spacer()
                Text(String("00:00"))
                Spacer()
            }
            
            Spacer()
        }
    }
}

struct WorkoutCardAudioView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardAudioView( recap: recaps[0])
    }
}

