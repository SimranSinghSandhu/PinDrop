//
//  ContentView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            if hasSeenOnboarding {
                TabView {
                    MapScreenView()
                        .tabItem {
                            Image(systemName: "map.circle")
                        }
                    AllPinsView()
                        .tabItem {
                            Image(systemName: "pin.circle")
                        }
                }
                .tint(Color.black)
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
