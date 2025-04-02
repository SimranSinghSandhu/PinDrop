//
//  LocationView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI

struct AllPinsView: View {
    var body: some View {
        VStack {
            AllPinsNavigationView()
            ScrollView {
                ForEach(0..<20) { i in
                    LocationPinView()
                }
            }
        }
    }
}

#Preview {
    AllPinsView()
}
