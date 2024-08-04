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
        let blueTristan = UIUtils.hexStringToColor(hex: "#5469ef")
        let purpleTristan = UIUtils.hexStringToColor(hex: "#cc84f6")
        let grayTristan = UIUtils.hexStringToColor(hex: "#292929")
        let gradient = LinearGradient(gradient:
                                        Gradient(colors:[blueTristan, purpleTristan]),
                                                 startPoint: .leading, endPoint: .trailing)
        ZStack{
            VStack(){
                HStack(){
                    Text(recap.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.leading)
                        .fontWeight(.semibold)
                    Spacer()
                }
                ZStack{
                    TabView {
                        WorkoutCardView(recap: recap)
                            .padding(.horizontal)
                        
                        WorkoutCardAudioView(recap: recap)
                            .padding(.horizontal)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.black)
                }
            }
            .padding()
            .background(gradient.opacity(0.7))
            .cornerRadius(20)
        }
    }
}

struct WorkoutCardHolderView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutCardHolderView( recap: recaps[0])
    }
}

