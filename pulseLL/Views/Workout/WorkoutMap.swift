//
//  WorkoutMap.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI
import MapKit

struct WorkoutMap: View {
    var body: some View {
        Map()
            .overlay {
                ZStack {
                    Rectangle()
                        .fill(.gray)
                        .blendMode(.colorBurn)
                    
                    Rectangle()
                        .fill(.black)
                        .blendMode(.hue)
                }
            }
            .padding(0)
    }
}
#Preview {
    WorkoutMap()
}
