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
    var body: some View {
                    VStack(){
                        HStack(){
                            Text("Workout1")
                            Spacer()
                        }
                        .padding()
                        ZStack{
                            Rectangle()
                                .fill(Color.gray.opacity(0.7))
                                .frame(height: 100)
                                .cornerRadius(10)
                                .padding(.horizontal)
                            Image("test")
                                .resizable()
                                .frame(height: 50)
                                .opacity(0.9)
                            
                        }
                    }
                    .padding()
                    .cornerRadius(25)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.2))
        }
    }

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardView()
    }
}
