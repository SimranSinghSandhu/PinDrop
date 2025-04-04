//
//  LocationView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import SwiftData
import CoreLocation

struct AllPinsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State var locations: [LocationPinItem]
    @State private var showFavOnly = false
    @State private var showActionSheetForNavigation = false
    
    var selectedLocation: CLLocation
    
    var body: some View {
        VStack {
            AllPinsNavigationView(showFavOnly: $showFavOnly)
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(locations) { location in
                            Button {
                                print("Location Name =", location.title)
                                self.showActionSheetForNavigation = true
                            } label: {
                                LocationPinView(locationItem: binding(for: location))
                            }
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
        .onAppear() {
            self.fetchLocations()
        }
        .onChange(of: showFavOnly) { oldValue, newValue in
            self.fetchLocations()
        }
        .confirmationDialog("Open in...", isPresented: $showActionSheetForNavigation) {
            if UIApplication.shared.canOpenURL(URL(string: "maps://")!) {
                Button("Apple Maps") {
                    openInAppleMaps(location: selectedLocation)
                }
            }
            
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                Button("Google Maps") {
                    openInGoogleMaps(location: selectedLocation)
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
    
    private func fetchLocations() {
        var descriptor = FetchDescriptor<LocationPinItem>(
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        
        if showFavOnly {
            descriptor.predicate = #Predicate { $0.isFav == true } // Filter favorites
        }
        
        locations = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func openInAppleMaps(location: CLLocation) {
        let url = URL(string: "http://maps.apple.com/?ll=\(location.coordinate.latitude),\(location.coordinate.longitude)")!
        UIApplication.shared.open(url)
    }
    
    private func openInGoogleMaps(location: CLLocation) {
        let url = URL(string: "comgooglemaps://?q=\(location.coordinate.latitude),\(location.coordinate.longitude)&zoom=14")!
        UIApplication.shared.open(url)
    }

}

#Preview {
    var locationItems: [LocationPinItem] = [
        LocationPinItem(title: "Dpchi", category: "asdf", image: UIImage(named: "dochiin"), createdDate: Date(), lat: 0.0, lng: 0.0)
    ]
    
    AllPinsView(locations: locationItems, selectedLocation: CLLocation(latitude: 0.0, longitude: 0.0))
}
