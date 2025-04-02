//
//  ContentView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
//            TabView {
//                AllPinsView()
//                    .tabItem {
//                        Image(systemName: "pin.circle")
//                    }
//                
//                MapScreenView()
//                    .tabItem {
//                        Image(systemName: "map.circle")
//                    }
//            }
//            .tint(Color.black)
            OnboardingView()
        }
    }
}

#Preview {
    ContentView()
}
