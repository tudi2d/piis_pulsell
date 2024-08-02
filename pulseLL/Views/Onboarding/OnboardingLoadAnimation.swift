//
//  OnboardingLoadAnimation.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 02.08.24.
//

import SwiftUI

struct AnimationView: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 20, height: 20)
                    .offset(y: animate ? -30 : 0)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.25),
                        value: animate
                    )
            }
        }
        .frame(width: 20, height: 20)
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    AnimationView()
}
