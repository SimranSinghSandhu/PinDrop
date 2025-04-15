//
//  MapScreenView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import MapKit

struct PinLocation {
    var coordinate: CLLocation
    var address: String
}

struct MapScreenView: View {
    
    @State private var permissionManager = PermissionManager()
    
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.7046, longitude: 06.7179), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)))
    
    @State private var myLocation: PinLocation?
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            Map(position: $position)
            .onReceive(permissionManager.$userLocation) { location in
                    if let location = location {
                        position = .region(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
                        ))
                    }
                }
            Image(systemName: "mappin")
                .font(.system(size: 34))
                .fontWeight(.bold)
                .foregroundStyle(Color.red)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        if permissionManager.authorisationStatus == .authorizedWhenInUse || permissionManager.authorisationStatus == .authorizedAlways {
                            Task {
                                if let address = await permissionManager.fetchAddress(),
                                   let location = permissionManager.userLocation {
                                    
                                    myLocation = PinLocation(coordinate: location, address: address)
                                    self.showSheet.toggle()
                                }
                            }
                        } else {
                            print("Location has been denied")
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.white)
                                .frame(width: 54)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 0)
                            Image(systemName: "plus")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                        }
                    }.padding(.all, 16)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            CreatePinView(myLocation: $myLocation)
                .presentationDetents([.height(455)])
        }
    }
}

#Preview {
    MapScreenView()
}
