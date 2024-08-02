//
//  ContentView.swift
//  pulseLL
//
//  Created by Tristan Häuser on 10.06.24.
//

import SwiftUI
import HealthKit
import HealthKitUI

let blueTristan = UIUtils.hexStringToColor(hex: "#5469ef")
let purpleTristan = UIUtils.hexStringToColor(hex: "#cc84f6")
let gradient = LinearGradient(gradient:
                                Gradient(colors:[blueTristan, purpleTristan]),
                                         startPoint: .leading, endPoint: .trailing)

struct HomeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var didStartWorkout = false
    @State private var triggerAuthorization = false
    
    var body: some View {
        NavigationStack{
            VStack {
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
                NavigationLink{
                    OnboardingView()
                } label: {
                    HStack {
                        Text("Workout your next song!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                    .background(gradient)
                    .cornerRadius(20)
                    .padding()
                .foregroundColor(.white)
                }
                
                RecapList()
            }
            .padding()
            .onAppear{
                triggerAuthorization.toggle()
                workoutManager.retrieveRemoteSession()
            }
            .healthDataAccessRequest(store: workoutManager.healthStore,
                                     shareTypes: workoutManager.typesToShare,
                                     readTypes: workoutManager.typesToRead,
                                     trigger: triggerAuthorization, completion: { result in
                 switch result {
                 case .success(let success):
                     print("\(success) for authorization")
                 case .failure(let error):
                     print("\(error) for authorization")
                 }
             })
        }.navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Preview: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(WorkoutManager.shared)
    }
}
