//
//  WorkoutStats.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI

struct WorkoutStats<TimeView: View>: View {
    var bpm: Int
    var genre: String
    var time: TimeView
    var distance: Double
    
    var body: some View {
        Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                GridRow {
                    StatView(label: String(bpm), subLabel: "bpm")
                    StatView(label: genre, subLabel: "")
                }
                GridRow {
                    TimeSupportView(time: time)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .background(Color.white)
                    StatView(label: String(format: "%.2f", distance), subLabel: "km")
                }
            }
            .background(Color(UIColor.systemGray6))
            .frame(alignment: .top)
        }
}

struct StatView: View {
    var label: String
    var subLabel: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline){
            Text(label)
                .font(.title)
                .fontWeight(.bold)
            
            if !subLabel.isEmpty {
                Text(subLabel)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.white)
    }
}

struct TimeSupportView <TimeView: View>: View {
    var time: TimeView
    var body: some View {
        ZStack{
            time
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.white)
    }
}

#Preview {
    WorkoutStats(bpm: 142, genre: "Techno", time: ElapsedTimeView(), distance: 1.2)
}
