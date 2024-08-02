//
//  workoutCardHolderView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 02.08.24.
//

import Foundation
import os
import SwiftUI

struct WorkoutCardHolderView : View {
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
                TabView {
                    WorkoutCardView(recap: recaps[0])
                        .padding(.horizontal)
                    
                    WorkoutCardView(recap: recaps[0])
                        .padding(.horizontal)
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
        }
        .padding()
        .cornerRadius(25)
        .foregroundColor(.black)
        .background(Color.gray.opacity(0.2))
    }
}

struct WorkoutCardHolderView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardHolderView( recap: recaps[0])
    }
}

