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
    var body: some View {
                    VStack(){
                        HStack(){
                            Text(recap.title)
                                .font(.headline)
                                .padding(.leading)
                            Spacer()
                        }
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
                    .padding()
                    .cornerRadius(25)
                    .foregroundColor(.black)
                    .background(Color.gray.opacity(0.2))
        }
    }

struct WorkoutCardView2_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardView( recap: recaps[0])
    }
}

