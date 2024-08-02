//
//  testCard.swift
//  pulseLL
//
//  Created by Tristan Häuser on 02.08.24.
//

import Foundation
import SwiftUI

struct testCardView: View {
    var body: some View {
        TabView {
            // First page of the card
            VStack {
                // Content goes here
                Text("Afternoon Run")
                    .font(.title)
                    .padding()
                Spacer()
            }
            .frame(width: 300, height: 200)
            .background(Color.blue)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()

            // Second page of the card
            VStack {
                // Content goes here
                Text("Your run in music")
                    .font(.title)
                    .padding()
                Spacer()
            }
            .frame(width: 300, height: 200)
            .background(Color.blue)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding()
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 250)
    }
}

struct testCardView_Previews: PreviewProvider {
    static var previews: some View {
        testCardView()
    }
}
