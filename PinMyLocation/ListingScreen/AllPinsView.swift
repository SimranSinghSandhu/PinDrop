//
//  LocationView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import SwiftData

struct AllPinsView: View {
    
//    @State private var locations: [LocationPinItem] = [
//        LocationPinItem(title: "Dpchi", category: "asdf", image: UIImage(named: "dochiin"), createdDate: "sadf")
//    ]
    
    @Query(sort: \LocationPinItem.createdDate, order: .reverse) private var locations: [LocationPinItem]
    
    var body: some View {
        VStack {
            AllPinsNavigationView()
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(locations) { location in
                            LocationPinView(locationItem: binding(for: location))
                        }
                    }
                }
                if locations.isEmpty {
                    VStack(spacing: 20) {
                        Text("Your saved locations will appear here.")
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                    }
                }
            }
        }
    }
    
    private func binding(for location: LocationPinItem) -> Binding<LocationPinItem> {
        guard let index = locations.firstIndex(where: { $0.id == location.id }) else {
            fatalError("Location not found")
        }
        return .constant(locations[index]) // Use .constant for now (will discuss updates)
    }
}

#Preview {
    AllPinsView()
}
