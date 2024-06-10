//
//  pulseLLTabView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 10.06.24.
//

import SwiftUI

struct pulseLLTabView: View {
    
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                }
            HeartRateView()
                .tag("heartrate")
                .tabItem {
                    Image(systemName: "heart")
                }
        }
    }
}

#Preview {
    pulseLLTabView()
}
