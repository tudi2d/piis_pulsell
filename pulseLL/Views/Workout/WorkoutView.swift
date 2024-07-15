//
//  WorkoutView.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI


struct WorkoutView: View {
    var body: some View {
        ZStack{
            VStack {
                WorkoutStats(bpm: 143, genre: "Techno", time: "00:35:12", distance: "6.2").zIndex(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                WorkoutMap()
                WorkoutControl().zIndex(1.0)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

#Preview {
    WorkoutView()
}
