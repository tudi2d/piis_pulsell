//
//  RecapItem.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 12.07.24.
//

import SwiftUI

struct RecapItem: View {
    var recap: Recap

    var body: some View {
        VStack {
            HStack {
                Text(recap.title)
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Placeholder for graph/waveform
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.7))
                    .frame(height: 100)
                    .cornerRadius(10)
                    .padding(.horizontal)
                .padding(.top)
                
                HStack {
                    Text(recap.genre)
                    Spacer()
                    Text(recap.time)
                    Spacer()
                    Text(String(recap.bpm) + "bpm")
                }
                .padding(.horizontal)
                .padding(.horizontal)
                .font(.subheadline)
                .foregroundColor(.white)
                .offset(y: -40)
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    RecapItem( recap: recaps[0])
}
