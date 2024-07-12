//
//  ContentView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 10.06.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // Top Bar
            HStack {
                Text("Welcome back, Tristan")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding(.trailing)
            }

            // User Profile
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Let's go for a TECHNO run!")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.leading)
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .padding()
            .background(Color.gray.opacity(0.7))
            .cornerRadius(20)
            .padding()
            .foregroundColor(.white)

            // Running Activity
            RecapList()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
