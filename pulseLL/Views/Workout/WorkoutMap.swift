//
//  WorkoutMap.swift
//  pulseLL
//
//  Created by Philipp Hugenroth on 15.07.24.
//

import SwiftUI
import MapKit

struct WorkoutMap: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 48.1299942833122, longitude: 11.56442103505048), // Default to San Francisco
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var route: MKRoute?
    
    private func fetchRouteFrom(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
        }
    }
    
    var polyline: MKPolyline {
        let coordinates = locationManager.locations.map { $0.coordinate }
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all){
                UserAnnotation()
            
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.black.opacity(0.7), lineWidth: 8)
                }
            }
        .onAppear {
            locationManager.startTracking()
            fetchRouteFrom(CLLocationCoordinate2D(latitude: 48.1299942833122, longitude: 11.56442103505048), to:CLLocationCoordinate2D(latitude: 48.15088662356101, longitude: 11.579995444253933))
        }
        .onDisappear {
            locationManager.stopTracking()
        }.onChange(of: locationManager.userLocation) {
            if let location = locationManager.userLocation {
                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                )
            }}
        .mapStyle(.standard(elevation: .flat, emphasis: .muted, pointsOfInterest: .excludingAll))
            .padding(0)
    }
}

#Preview {
    WorkoutMap()
}
