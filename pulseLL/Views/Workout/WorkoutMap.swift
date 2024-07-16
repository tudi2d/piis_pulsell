//
//  WorkoutMap.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI
import MapKit

struct WorkoutMap: View {
    @StateObject private var locationModel = LocationManager()
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all){
                UserAnnotation()
            }
        .mapStyle(.standard(elevation: .flat,emphasis: .muted, pointsOfInterest: .excludingAll))
            .task {
                locationModel.startTracking()
            }
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
            .onDisappear {
                locationModel.stopTracking()
            }
            .onChange(of: locationModel.userLocation) {
                if let location = locationModel.userLocation {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )
                }
            }
    }
}
#Preview {
    WorkoutMap()
}
