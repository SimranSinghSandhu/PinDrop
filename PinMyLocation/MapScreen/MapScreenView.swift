//
//  MapScreenView.swift
//  PinMyLocation
//
//  Created by Simran Sandhu on 01/04/25.
//

import SwiftUI
import MapKit

struct MapScreenView: View {
    
    @State private var position: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.7046, longitude: 76.7179), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)))
    
    @State private var coordinates: CLLocationCoordinate2D?
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            Map(position: $position)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        coordinates = CLLocationCoordinate2D(latitude: 30.7046, longitude: 76.7179)
                        self.showSheet.toggle()
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
            CreatePinView(coordinates: $coordinates)
                .presentationDetents([.height(455)])
        }
    }
}

#Preview {
    MapScreenView()
}
