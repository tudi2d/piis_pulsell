//
//  audioPlayerSliderView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 03.08.24.
//

import Foundation
import SwiftUI

struct audioPlayerSliderView: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var onEditingChanged: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Track
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                
                // Progress
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width, height: 4)
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .offset(x: CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * geometry.size.width - 10)
                    .gesture(DragGesture().onChanged({ gesture in
                        let newValue = Double(gesture.location.x / geometry.size.width) * (range.upperBound - range.lowerBound) + range.lowerBound
                        value = min(max(newValue, range.lowerBound), range.upperBound)
                    }).onEnded({ _ in
                        onEditingChanged()
                    }))
            }
        }
        .frame(height: 20)
    }
}
