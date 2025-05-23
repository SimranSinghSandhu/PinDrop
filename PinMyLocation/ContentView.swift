//
//  ContentView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import SwiftData

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
                    AllPinsView(locations: [])
                        .tabItem {
                            Image(systemName: "pin.circle")
                        }
                }
                .tint(Color.black)
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: LocationPinItem.self)
        .onOpenURL { url in
            print("Opened with URL: \(url)")
        }
    }
}

#Preview {
    ContentView()
}
