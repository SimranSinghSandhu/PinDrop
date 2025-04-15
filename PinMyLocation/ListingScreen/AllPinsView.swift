//
//  LocationView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import SwiftData
import CoreLocation

struct ShareSheetItem: Identifiable {
    let id = UUID()
    var title: String
}

struct AllPinsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var swiftDataManager = SwiftDataManager()
    @State var locations: [LocationPinItem]
    @State private var showFavOnly = false
    @State private var showActionSheetForNavigation = false
    
    @State private var selectedLocation: LocationPinItem? = nil
    
//    @State private var shareText = ""
    @State private var showSheet = false
    @State private var message = "a message"
    
    var body: some View {
        VStack {
            AllPinsNavigationView(showFavOnly: $showFavOnly)
            ZStack {
                List {
                    ForEach(locations) { location in
                        LocationPinView(locationItem: binding(for: location))
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    print("Delete Btn tapped")
                                    swiftDataManager.deleteItem(for: location, modelContext: modelContext)
                                    if let index = locations.firstIndex(where: { $0.id == location.id }) {
                                        locations.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.title3)
                                        .foregroundStyle(.red)
                                }
                                .tint(.red)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    message = "pingo://"
                                    showSheet = true
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.title3)
                                        .foregroundStyle(.red)
                                }
                                .tint(.green)
                                
                                Button {
                                    print("Heart Btn tapped", location.title)
                                    swiftDataManager.updateItem(for: location, modelContext: modelContext)
                                } label: {
                                    Image(systemName: "heart")
                                        .font(.title3)
                                        .foregroundStyle(.red)
                                }
                                .tint(.blue)
                            }
                            .onTapGesture {
                                selectedLocation = location
                                showActionSheetForNavigation = true
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
                    if let selectedLocation = selectedLocation {
                        openInAppleMaps(location: selectedLocation)
                    }
                }
            }
            
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                Button("Google Maps") {
                    if let selectedLocation = selectedLocation {
                        openInGoogleMaps(location: selectedLocation)
                    }
                }
            }
        }
        if showSheet {
            ActivityViewController(text: $message, showing: $showSheet)
                .frame(width: 0, height: 0)
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
        
//        locations = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func openInAppleMaps(location: LocationPinItem) {
        let latitude = location.lat
        let longitude = location.lng
        let placeName = location.title // Change this to any label you want

        if let url = URL(string: "http://maps.apple.com/?q=\(placeName)&ll=\(latitude),\(longitude)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openInGoogleMaps(location: LocationPinItem) {
        let latitude = location.lat
        let longitude = location.lng
        let placeName = location.title // Change this to any label you want

        if let url = URL(string: "comgooglemaps://?q=\(placeName)@\(latitude),\(longitude)&zoom=14") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    var locationItems: [LocationPinItem] = [
        LocationPinItem(title: "Dpchi", category: "asdf", image: UIImage(named: "dochiin"), createdDate: Date(), lat: 0.0, lng: 0.0),
        LocationPinItem(title: "Dpchi3", category: "asdf", image: UIImage(named: "dochiin"), createdDate: Date(), lat: 0.0, lng: 0.0)
    ]
    
    AllPinsView(locations: locationItems)
}
